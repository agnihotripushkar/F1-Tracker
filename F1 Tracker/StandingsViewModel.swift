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
    var error: F1LoadError?

    private let repo: any F1RepositoryProtocol

    init(repo: any F1RepositoryProtocol) {
        self.repo = repo
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
            handle(error)
        }
        isLoading = false
    }

    func refresh() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        do {
            async let drivers      = repo.refreshDriverStandings()
            async let constructors = repo.refreshConstructorStandings()
            (driverStandings, constructorStandings) = try await (drivers, constructors)
        } catch {
            handle(error)
        }
        isLoading = false
    }

    // MARK: - Private

    private func handle(_ error: Error) {
        guard !(error is CancellationError) else { return }
        self.error = F1LoadError(error)
    }
}
