//
//  OnboardingPage3.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Page 3: F1 Premium / Driver Card

struct OnboardingPage3: View {
    @Binding var hasCompletedOnboarding: Bool

    let recentResults: [(position: String, circuit: String, isHighlight: Bool)] = [
        ("P2", "SPA", false),
        ("P1", "SIL", true),
        ("P4", "HUN", false),
        ("P3", "ZAN", false),
        ("P6", "MON", false)
    ]

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.05, blue: 0.08)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack(spacing: 8) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 18, weight: .black))
                        .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.0))
                    HStack(spacing: 0) {
                        Text("F1 ")
                            .font(.system(size: 20, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                        Text("PREMIUM")
                            .font(.system(size: 20, weight: .black, design: .monospaced))
                            .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.0))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 56)
                .padding(.bottom, 20)

                // Driver card
                LewisHamiltonCard()
                    .padding(.horizontal, 20)

                Spacer()
                    .frame(height: 16)

                // Swift Performance section
                SwiftPerformanceCard(results: recentResults)
                    .padding(.horizontal, 20)

                Spacer()

                // GET STARTED button
                VStack(spacing: 16) {
                    Button {
                        hasCompletedOnboarding = true
                    } label: {
                        HStack(spacing: 10) {
                            Text("GET STARTED")
                                .font(.system(size: 17, weight: .black, design: .monospaced))
                                .tracking(2)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color(red: 1.0, green: 0.45, blue: 0.0))
                        .cornerRadius(14)
                    }
                    .padding(.horizontal, 20)

                    PageDotsView(current: 2, total: 3, activeColor: Color(red: 1.0, green: 0.45, blue: 0.0))
                        .padding(.bottom, 8)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Lewis Hamilton Driver Card

struct LewisHamiltonCard: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Card background
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)

            // Driver portrait
            Group {
                if let _ = UIImage(named: "LewisHamilton") {
                    Image("LewisHamilton")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .clipped()
                } else {
                    // Placeholder when image not yet added to assets
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(white: 0.7),
                                    Color(white: 0.5),
                                    Color(white: 0.35)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 300)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 80))
                                .foregroundColor(Color.white.opacity(0.4))
                        )
                }
            }
            .cornerRadius(20)

            // Bottom overlay gradient
            LinearGradient(
                colors: [Color.clear, Color(red: 0.05, green: 0.05, blue: 0.08).opacity(0.9)],
                startPoint: .center,
                endPoint: .bottom
            )
            .cornerRadius(20)

            // Driver info overlay
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Lewis Hamilton")
                        .font(.system(size: 26, weight: .black))
                        .foregroundColor(.white)
                    Text("SCUDERIA FERRARI")
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.0))
                        .lineSpacing(2)
                }

                Spacer()

                VStack(alignment: .center, spacing: 2) {
                    Text("CHAMPIONSHIPS")
                        .font(.system(size: 9, weight: .semibold, design: .monospaced))
                        .tracking(1)
                        .foregroundColor(Color.white.opacity(0.6))
                    HStack(alignment: .bottom, spacing: 4) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color.white.opacity(0.3))
                        Text("7")
                            .font(.system(size: 48, weight: .black))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(20)
        }
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 6)
    }
}

// MARK: - Swift Performance Card

struct SwiftPerformanceCard: View {
    let results: [(position: String, circuit: String, isHighlight: Bool)]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("SWIFT PERFORMANCE")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .tracking(1)
                    .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.0))
                Spacer()
                Text("LAST 5 GRAND PRIX")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .tracking(1)
                    .foregroundColor(Color.white.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 20)

            HStack(spacing: 0) {
                ForEach(results, id: \.circuit) { result in
                    VStack(spacing: 6) {
                        Text(result.position)
                            .font(.system(size: 18, weight: .black, design: .monospaced))
                            .foregroundColor(result.isHighlight ? Color(red: 1.0, green: 0.45, blue: 0.0) : .white)
                        Text(result.circuit)
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .tracking(1)
                            .foregroundColor(Color.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(red: 0.12, green: 0.10, blue: 0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
        )
    }
}
