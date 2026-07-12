//
//  OnboardingView.swift
//  F1 Tracker
//
//  Created by csuftitan on 3/11/26.
//

import SwiftUI
import UIKit

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentPage) {
                OnboardingPage1(currentPage: $currentPage)
                    .tag(0)
                OnboardingPage2(currentPage: $currentPage)
                    .tag(1)
                OnboardingPage3(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
