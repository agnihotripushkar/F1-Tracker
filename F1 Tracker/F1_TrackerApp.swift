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
        let container = try! ModelContainer(for: schema)
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
