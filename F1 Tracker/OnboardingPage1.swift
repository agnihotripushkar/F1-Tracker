//
//  OnboardingPage1.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Page 1: Live Race Action

struct OnboardingPage1: View {
    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            // Dark background
            Color(red: 0.05, green: 0.05, blue: 0.05)
                .ignoresSafeArea()

            // Subtle car background blur overlay
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.08, blue: 0.03),
                        Color(red: 0.05, green: 0.05, blue: 0.05)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }

            VStack(spacing: 0) {
                // Top indicator pill
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 80, height: 6)
                    .padding(.top, 16)

                Spacer()
                    .frame(height: 24)

                // Live Race Widget Card
                LiveRaceWidgetCard()
                    .padding(.horizontal, 20)

                Spacer()

                // Bottom content
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Text("LIVE RACE ACTION,")
                            .font(.system(size: 34, weight: .black, design: .default))
                            .italic()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        Text("STRAIGHT TO YOUR\nLOCK SCREEN")
                            .font(.system(size: 34, weight: .black, design: .default))
                            .italic()
                            .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.0))
                            .multilineTextAlignment(.center)
                    }

                    Text("Get real-time updates and never miss an\novertake with innovative Live Activities and\nDynamic Island integration.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    // Page dots
                    PageDotsView(current: 0, total: 3, activeColor: Color(red: 1.0, green: 0.45, blue: 0.0))
                        .padding(.bottom, 8)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Live Race Widget Card

struct LiveRaceWidgetCard: View {
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(red: 1.0, green: 0.45, blue: 0.0))
                        .frame(width: 14, height: 14)
                    Text("LIVE RACE ACTION")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .tracking(1)
                        .foregroundColor(.white)
                }
                Spacer()
                Text("Lap 45/70")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.7))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 14)

            // Drivers row
            HStack(alignment: .top) {
                // Verstappen
                HStack(spacing: 10) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 4, height: 40)
                        .cornerRadius(2)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Verstappen")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Text("Red Bull Racing")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.55))
                    }
                }

                Spacer()

                Text("+1.24s")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.0))

                Spacer()

                // Leclerc
                HStack(spacing: 10) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Leclerc")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Text("Scuderia Ferrari")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.55))
                    }
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 4, height: 40)
                        .cornerRadius(2)
                }
            }
            .padding(.horizontal, 16)

            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

            // Race Progress
            VStack(spacing: 8) {
                HStack {
                    Text("RACE PROGRESS")
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .tracking(1)
                        .foregroundColor(Color.white.opacity(0.5))
                    Spacer()
                    Text("64% Complete")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color(red: 1.0, green: 0.45, blue: 0.0))
                            .frame(width: geo.size.width * 0.64, height: 6)
                    }
                }
                .frame(height: 6)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(red: 0.12, green: 0.12, blue: 0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }
}
