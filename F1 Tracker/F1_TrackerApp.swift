//
//  F1_TrackerApp.swift
//  F1 Tracker
//
//  Created by csuftitan on 3/11/26.
//

import SwiftUI
import SwiftData

@MainActor
@main
struct F1_TrackerApp: App {
    private let container: ModelContainer
    private let dependencies: AppDependencies

    init() {
        let schema = Schema([
            CachedDriverStanding.self,
            CachedConstructorStanding.self,
            CachedRace.self,
            CachedWeather.self
        ])
        let container: ModelContainer
        do {
            container = try ModelContainer(for: schema)
        } catch {
            // Fall back to an in-memory store so a corrupt/incompatible on-disk
            // cache can't hard-crash the app on launch — worst case we lose
            // the local cache for this session instead of losing the app.
            let fallbackConfig = ModelConfiguration(isStoredInMemoryOnly: true)
            container = (try? ModelContainer(for: schema, configurations: fallbackConfig))
                ?? { fatalError("Failed to create in-memory ModelContainer fallback: \(error)") }()
        }
        self.container = container
        self.dependencies = .live(modelContext: container.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: dependencies)
                .modelContainer(container)
        }
    }
}
