// OpenF1Service.swift
// Network actor for the OpenF1 API (live timing, weather)

import Foundation

protocol OpenF1Servicing: Sendable {
    func fetchLatestWeather() async throws -> OpenF1WeatherResponse?
    func fetchIntervals() async throws -> [OpenF1IntervalResponse]
    func fetchLatestPositions() async throws -> [OpenF1PositionResponse]
    func fetchDrivers() async throws -> [OpenF1DriverResponse]
}

// Shared error type for all F1 services
enum F1ServiceError: LocalizedError {
    case invalidURL
    case badResponse
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:   return "Invalid API URL."
        case .badResponse:  return "The server returned an unexpected response."
        case .noData:       return "No data available for the current session."
        }
    }
}

actor OpenF1Service {
    private let baseURL = "https://api.openf1.org/v1"
    private let session: URLSession

    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
    }

    // MARK: - Public endpoints

    func fetchLatestWeather() async throws -> OpenF1WeatherResponse? {
        let url = try makeURL("\(baseURL)/weather?session_key=latest")
        let results: [OpenF1WeatherResponse] = try await fetchArray(url)
        return results.last
    }

    func fetchIntervals() async throws -> [OpenF1IntervalResponse] {
        let url = try makeURL("\(baseURL)/intervals?session_key=latest")
        return try await fetchArray(url)
    }

    /// Returns only the most-recent position entry per driver.
    func fetchLatestPositions() async throws -> [OpenF1PositionResponse] {
        let url = try makeURL("\(baseURL)/position?session_key=latest")
        let all: [OpenF1PositionResponse] = try await fetchArray(url)
        var seen = Set<Int>()
        return all.reversed().filter { seen.insert($0.driverNumber).inserted }.reversed()
    }

    func fetchDrivers() async throws -> [OpenF1DriverResponse] {
        let url = try makeURL("\(baseURL)/drivers?session_key=latest")
        return try await fetchArray(url)
    }

    // MARK: - Private helpers

    private func makeURL(_ string: String) throws -> URL {
        guard let url = URL(string: string) else { throw F1ServiceError.invalidURL }
        return url
    }

    private func fetchArray<T: Decodable>(_ url: URL) async throws -> [T] {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw F1ServiceError.badResponse
        }
        return try JSONDecoder().decode([T].self, from: data)
    }
}

extension OpenF1Service: OpenF1Servicing {}
