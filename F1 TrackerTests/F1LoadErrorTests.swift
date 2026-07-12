// F1LoadErrorTests.swift
// Unit tests for F1LoadError's retryable-vs-fatal classification.

import Testing
import Foundation
@testable import F1_Tracker

struct F1LoadErrorTests {

    @Test func serverErrorsAreRetryable() {
        let error = F1LoadError(F1ServiceError.badResponse(statusCode: 503))
        #expect(error.isRetryable)
    }

    @Test func clientErrorsAreNotRetryable() {
        let error = F1LoadError(F1ServiceError.badResponse(statusCode: 404))
        #expect(!error.isRetryable)
    }

    @Test func badResponseWithNoStatusCodeIsTreatedAsRetryable() {
        let error = F1LoadError(F1ServiceError.badResponse(statusCode: nil))
        #expect(error.isRetryable)
    }

    @Test func invalidURLIsNotRetryable() {
        let error = F1LoadError(F1ServiceError.invalidURL)
        #expect(!error.isRetryable)
    }

    @Test func urlErrorsAreRetryable() {
        let error = F1LoadError(URLError(.timedOut))
        #expect(error.isRetryable)
    }

    @Test func decodingErrorsAreNotRetryable() {
        struct Dummy: Decodable {}
        let decodeError = DecodingError.dataCorrupted(
            .init(codingPath: [], debugDescription: "bad json")
        )
        let error = F1LoadError(decodeError)
        #expect(!error.isRetryable)
    }
}
