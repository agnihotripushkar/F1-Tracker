// StandingsViewModel.swift
// Presentation layer — depends only on F1RepositoryProtocol + domain models.
// No SwiftData, no networking, no DTO imports.

import Foundation
import Observation

@MainActor
@Observable
final class StandingsViewModel {

    var driverStandings:      [F1DriverStanding]      = []
    var constructorStandings: [F1ConstructorStanding] = []
    var isLoading = false
    var error: String?

    private let repo: any F1RepositoryProtocol

    /// Pass nil (default) for the production repository, or inject a mock for tests/previews.
    init(repo: (any F1RepositoryProtocol)? = nil) {
        self.repo = repo ?? F1Repository.shared
    }

    // MARK: - Intents

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        do {
            async let drivers      = repo.driverStandings()
            async let constructors = repo.constructorStandings()
            (driverStandings, constructorStandings) = try await (drivers, constructors)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    func refresh() async {
        isLoading = true
        error = nil
        do {
            async let drivers      = repo.refreshDriverStandings()
            async let constructors = repo.refreshConstructorStandings()
            (driverStandings, constructorStandings) = try await (drivers, constructors)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
