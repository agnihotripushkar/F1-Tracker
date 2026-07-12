// F1LoadError.swift
// Typed load-error surface for ViewModels, so views can distinguish a
// transient failure worth offering a retry for from a permanent one.

import Foundation

struct F1LoadError: Equatable {
    let message: String
    let isRetryable: Bool

    init(_ error: Error) {
        message = error.localizedDescription
        switch error {
        case let serviceError as F1ServiceError:
            switch serviceError {
            case .badResponse(let statusCode):
                isRetryable = statusCode.map { $0 >= 500 } ?? true
            case .invalidURL, .noData:
                isRetryable = false
            }
        case is URLError:
            isRetryable = true
        default:
            isRetryable = false
        }
    }
}
