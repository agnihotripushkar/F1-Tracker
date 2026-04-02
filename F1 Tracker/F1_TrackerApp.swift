//
//  F1_TrackerApp.swift
//  F1 Tracker
//
//  Created by csuftitan on 3/11/26.
//

import SwiftUI
import SwiftData

@main
struct F1_TrackerApp: App {
    let container: ModelContainer = {
        let schema = Schema([
            CachedDriverStanding.self,
            CachedConstructorStanding.self,
            CachedRace.self,
            CachedWeather.self
        ])
        return try! ModelContainer(for: schema)
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .task {
                    // Wire the repository to the main SwiftData context
                    F1Repository.shared.configure(with: container.mainContext)
                }
        }
    }
}
