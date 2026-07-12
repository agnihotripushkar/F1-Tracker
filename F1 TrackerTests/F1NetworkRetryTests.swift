// F1NetworkRetryTests.swift
// Unit tests for F1NetworkRetry's retry/backoff decisions.

import Testing
import Foundation
@testable import F1_Tracker

struct F1NetworkRetryTests {

    @Test func succeedsWithoutRetryingOnFirstSuccess() async throws {
        var attempts = 0
        let result = try await F1NetworkRetry.withRetry {
            attempts += 1
            return "ok"
        }
        #expect(result == "ok")
        #expect(attempts == 1)
    }

    @Test func retriesTransientErrorsUpToMaxAttempts() async {
        var attempts = 0
        await #expect(throws: URLError.self) {
            try await F1NetworkRetry.withRetry {
                attempts += 1
                throw URLError(.timedOut)
            }
        }
        #expect(attempts == F1NetworkRetry.maxAttempts)
    }

    @Test func doesNotRetryClientErrors() async {
        var attempts = 0
        await #expect(throws: F1ServiceError.self) {
            try await F1NetworkRetry.withRetry {
                attempts += 1
                throw F1ServiceError.badResponse(statusCode: 404)
            }
        }
        #expect(attempts == 1)
    }

    @Test func retriesServerErrors() async {
        var attempts = 0
        await #expect(throws: F1ServiceError.self) {
            try await F1NetworkRetry.withRetry {
                attempts += 1
                throw F1ServiceError.badResponse(statusCode: 500)
            }
        }
        #expect(attempts == F1NetworkRetry.maxAttempts)
    }
}
