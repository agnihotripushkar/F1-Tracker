// HomeViewModel.swift
// Presentation layer — depends only on F1RepositoryProtocol + domain models.

import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {

    var races:    [F1Race]   = []
    var weather:  F1Weather?
    var isLoading = false
    var error: String?

    /// The next race that hasn't started yet.
    var nextRace: F1Race? { races.first { $0.isUpcoming } }

    /// Delegates to F1Race.nextSession so the ViewModel stays thin.
    var nextSession: (name: String, date: Date)? { nextRace?.nextSession }

    private let repo: any F1RepositoryProtocol

    init(repo: (any F1RepositoryProtocol)? = nil) {
        self.repo = repo ?? F1Repository.shared
    }

    // MARK: - Intents

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        do {
            async let schedule      = repo.raceSchedule()
            async let latestWeather = repo.latestWeather()
            (races, weather) = try await (schedule, latestWeather)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }

    func refreshWeather() async {
        do { weather = try await repo.refreshWeather() }
        catch { self.error = error.localizedDescription }
    }
}
