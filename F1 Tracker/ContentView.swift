//
//  ContentView.swift
//  F1 Tracker
//
//  Created by csuftitan on 3/11/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        if hasCompletedOnboarding {
            SplashScreenView()
        } else {
            OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
        }
    }
}

#Preview {
    ContentView()
}
