//
//  OnboardingView.swift
//  F1 Tracker
//
//  Created by csuftitan on 3/11/26.
//

import SwiftUI

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

// MARK: - Page 2: Data & Analytics

struct OnboardingPage2: View {
    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.06, blue: 0.10)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // F1 Analytics header
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 4, height: 24)
                        .cornerRadius(2)
                    Text("F1ANALYTICS")
                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                        .foregroundColor(Color.white.opacity(0.9))
                }
                .padding(.top, 56)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
                    .frame(height: 24)

                // Standings + Chart row
                HStack(alignment: .top, spacing: 12) {
                    // Driver standings
                    VStack(spacing: 10) {
                        DriverStandingRow(initials: "MV", initialsColor: Color(red: 0.15, green: 0.35, blue: 0.9), team: "RED BULL", name: "Verstappen", points: "0 PTS")
                        DriverStandingRow(initials: "LH", initialsColor: Color.red, team: "FERRARI", name: "Hamilton", points: "0 PTS")
                        DriverStandingRow(initials: "LN", initialsColor: Color(red: 1.0, green: 0.55, blue: 0.0), team: "MCLAREN", name: "Norris", points: "0 PTS")
                    }
                    .frame(maxWidth: .infinity)

                    // Chart
                    ConstructorsChartView()
                        .frame(width: 160, height: 200)
                }
                .padding(.horizontal, 20)

                Spacer()

                // Bottom content
                VStack(spacing: 20) {
                    VStack(spacing: 6) {
                        Text("UNRIVALED DATA")
                            .font(.system(size: 36, weight: .black, design: .default))
                            .italic()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text("& ANALYTICS")
                            .font(.system(size: 36, weight: .black, design: .default))
                            .italic()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }

                    Text("Explore detailed championship standings for\ndrivers and constructors, and follow every\npoint with advanced visualizations.")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    PageDotsView(current: 1, total: 3, activeColor: .red)
                        .padding(.bottom, 8)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Driver Standing Row

struct DriverStandingRow: View {
    let initials: String
    let initialsColor: Color
    let team: String
    let name: String
    let points: String

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(initialsColor)
                .frame(width: 42, height: 42)
                .overlay(
                    Text(initials)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(team)
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .tracking(1)
                    .foregroundColor(Color.white.opacity(0.5))
                Text(name)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                Text(points)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.65))
            }

            Spacer()
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.06))
        )
    }
}

// MARK: - Constructors Chart View

struct ConstructorsChartView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.07, green: 0.09, blue: 0.14))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("CONSTRUCTORS")
                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                    .tracking(1)
                    .foregroundColor(Color.white.opacity(0.4))
                    .padding([.top, .leading], 10)

                GeometryReader { geo in
                    ZStack {
                        // Dotted grid lines
                        VStack(spacing: 0) {
                            ForEach(0..<4) { i in
                                Spacer()
                                Rectangle()
                                    .fill(Color.white.opacity(0.08))
                                    .frame(height: 0.5)
                            }
                            Spacer()
                        }

                        // Chart lines (stylized curves)
                        ChartLine(
                            points: [
                                CGPoint(x: 0.0, y: 0.95),
                                CGPoint(x: 0.2, y: 0.85),
                                CGPoint(x: 0.4, y: 0.65),
                                CGPoint(x: 0.6, y: 0.45),
                                CGPoint(x: 0.8, y: 0.25),
                                CGPoint(x: 1.0, y: 0.08)
                            ],
                            color: Color(red: 0.1, green: 0.4, blue: 1.0)
                        )
                        .frame(width: geo.size.width, height: geo.size.height)

                        ChartLine(
                            points: [
                                CGPoint(x: 0.0, y: 0.95),
                                CGPoint(x: 0.2, y: 0.92),
                                CGPoint(x: 0.4, y: 0.78),
                                CGPoint(x: 0.6, y: 0.58),
                                CGPoint(x: 0.8, y: 0.42),
                                CGPoint(x: 1.0, y: 0.25)
                            ],
                            color: Color.red
                        )
                        .frame(width: geo.size.width, height: geo.size.height)

                        ChartLine(
                            points: [
                                CGPoint(x: 0.0, y: 0.95),
                                CGPoint(x: 0.2, y: 0.93),
                                CGPoint(x: 0.4, y: 0.85),
                                CGPoint(x: 0.6, y: 0.65),
                                CGPoint(x: 0.8, y: 0.50),
                                CGPoint(x: 1.0, y: 0.32)
                            ],
                            color: Color(red: 0.0, green: 0.85, blue: 0.75)
                        )
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
    }
}

struct ChartLine: View {
    let points: [CGPoint]
    let color: Color

    var body: some View {
        GeometryReader { geo in
            Path { path in
                guard points.count > 1 else { return }
                let w = geo.size.width
                let h = geo.size.height
                let first = points[0]
                path.move(to: CGPoint(x: first.x * w, y: first.y * h))
                for i in 1..<points.count {
                    let prev = points[i - 1]
                    let curr = points[i]
                    let cp1 = CGPoint(x: (prev.x * w + curr.x * w) / 2, y: prev.y * h)
                    let cp2 = CGPoint(x: (prev.x * w + curr.x * w) / 2, y: curr.y * h)
                    path.addCurve(
                        to: CGPoint(x: curr.x * w, y: curr.y * h),
                        control1: cp1,
                        control2: cp2
                    )
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            .shadow(color: color.opacity(0.8), radius: 4, x: 0, y: 0)
        }
    }
}

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
                    Text("F1 ")
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                    + Text("PREMIUM")
                        .font(.system(size: 20, weight: .black, design: .monospaced))
                        .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.0))
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
                        .foregroundColor(Color(red: 0.05, green: 0.05, blue: 0.08))
                        .frame(maxWidth: .infinity)
                        .frame(height: 58)
                        .background(Color(red: 0.0, green: 0.88, blue: 0.78))
                        .cornerRadius(14)
                    }
                    .padding(.horizontal, 20)

                    PageDotsView(current: 2, total: 3, activeColor: Color(red: 0.0, green: 0.88, blue: 0.78))
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

// MARK: - Page Dots Indicator

struct PageDotsView: View {
    let current: Int
    let total: Int
    let activeColor: Color

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { i in
                if i == current {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(activeColor)
                        .frame(width: 28, height: 6)
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
