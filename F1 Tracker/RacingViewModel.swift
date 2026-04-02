// RacingViewModel.swift
// Presentation layer — adaptive polling with stale-data detection.
// The ViewModel knows nothing about OpenF1Service or SwiftData.
// All data fetching is delegated to F1RepositoryProtocol.fetchLiveTiming().

import Foundation
import Observation

@MainActor
@Observable
final class RacingViewModel {

    var timingEntries: [F1TimingEntry] = []
    var isLoading    = false
    var isLive       = false
    var lastUpdated: Date?
    var error: String?

    /// True when the last successful update was more than 30 seconds ago.
    var isDataStale: Bool {
        guard let lastUpdated else { return false }
        return Date.now.timeIntervalSince(lastUpdated) > 30
    }

    private let repo: any F1RepositoryProtocol
    private var pollingTask: Task<Void, Never>?

    init(repo: any F1RepositoryProtocol) {
        self.repo = repo
    }

    // MARK: - Polling control

    func startPolling() {
        pollingTask?.cancel()
        pollingTask = Task {
            while !Task.isCancelled {
                await fetch()
                // Poll every 5 s during a live session, 30 s otherwise.
                let interval: Duration = isLive ? .seconds(5) : .seconds(30)
                try? await Task.sleep(for: interval)
            }
        }
    }

    func stopPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }

    // MARK: - Private

    private func fetch() async {
        isLoading = true
        do {
            timingEntries = try await repo.fetchLiveTiming()
            lastUpdated   = .now
            isLive        = !timingEntries.isEmpty
            error         = nil
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
