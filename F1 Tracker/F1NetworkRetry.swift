// F1NetworkRetry.swift
// Shared retry-with-backoff helper for transient network failures.
// Race-day traffic to OpenF1/Jolpica sees frequent timeouts and 5xx
// responses under load — a single retry with backoff meaningfully
// improves success rate without masking persistent failures.

import Foundation

enum F1NetworkRetry {
    static let maxAttempts = 3
    private static let baseDelay: Duration = .milliseconds(400)

    static func withRetry<T: Sendable>(
        _ operation: @Sendable () async throws -> T
    ) async throws -> T {
        var lastError: Error = F1ServiceError.noData
        for attempt in 0..<maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                guard isRetryable(error), attempt < maxAttempts - 1 else { throw error }
                try await Task.sleep(for: baseDelay * (1 << attempt))
            }
        }
        throw lastError
    }

    private static func isRetryable(_ error: Error) -> Bool {
        switch error {
        case let urlError as URLError:
            switch urlError.code {
            case .timedOut, .networkConnectionLost, .notConnectedToInternet,
                 .cannotConnectToHost, .dnsLookupFailed, .cannotFindHost:
                return true
            default:
                return false
            }
        case F1ServiceError.badResponse(let statusCode):
            // Retry on server-side failures; a 4xx is our own fault and won't
            // change on retry.
            return statusCode.map { $0 >= 500 } ?? true
        default:
            return false
        }
    }
}
