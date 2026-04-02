// JolpicaService.swift
// Network actor for the Jolpica-F1 (Ergast-compatible) API

import Foundation

actor JolpicaService {
    static let shared = JolpicaService()

    private let baseURL = "https://api.jolpi.ca/ergast/f1"
    private let session: URLSession

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.waitsForConnectivity = true
        self.session = URLSession(configuration: config)
    }

    // MARK: - Public endpoints

    func fetchDriverStandings() async throws -> [JolpicaDriverStandingsResponse.DriverStanding] {
        let url = try makeURL("\(baseURL)/current/driverStandings")
        let response: JolpicaDriverStandingsResponse = try await fetch(url)
        return response.mrData.standingsTable.standingsLists.first?.driverStandings ?? []
    }

    func fetchConstructorStandings() async throws -> [JolpicaConstructorStandingsResponse.ConstructorStanding] {
        let url = try makeURL("\(baseURL)/current/constructorStandings")
        let response: JolpicaConstructorStandingsResponse = try await fetch(url)
        return response.mrData.standingsTable.standingsLists.first?.constructorStandings ?? []
    }

    func fetchRaceSchedule() async throws -> [JolpicaScheduleResponse.Race] {
        let url = try makeURL("\(baseURL)/current")
        let response: JolpicaScheduleResponse = try await fetch(url)
        return response.mrData.raceTable.races
    }

    // MARK: - Private helpers

    private func makeURL(_ string: String) throws -> URL {
        guard let url = URL(string: string) else { throw F1ServiceError.invalidURL }
        return url
    }

    private func fetch<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw F1ServiceError.badResponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
