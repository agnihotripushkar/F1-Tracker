// F1RepositoryProtocol.swift
// Domain-layer contract for all data access.
//
// Dependency rule:
//   Presentation  →  depends on this protocol  (never on F1Repository directly)
//   Data          →  F1Repository conforms to this protocol
//
// @MainActor on the protocol ensures conformers and callers share the same
// isolation, letting ViewModels call methods without extra await hopping.

import Foundation

@MainActor
protocol F1RepositoryProtocol: AnyObject {

    // MARK: Cache-first reads (local → network if stale)
    func driverStandings()      async throws -> [F1DriverStanding]
    func constructorStandings() async throws -> [F1ConstructorStanding]
    func raceSchedule()         async throws -> [F1Race]
    func latestWeather()        async throws -> F1Weather?

    // MARK: Force-refresh from network
    @discardableResult
    func refreshDriverStandings()      async throws -> [F1DriverStanding]
    @discardableResult
    func refreshConstructorStandings() async throws -> [F1ConstructorStanding]
    @discardableResult
    func refreshRaceSchedule()         async throws -> [F1Race]
    @discardableResult
    func refreshWeather()              async throws -> F1Weather?

    // MARK: Live timing (stateless — no local cache)
    func fetchLiveTiming() async throws -> [F1TimingEntry]
}
