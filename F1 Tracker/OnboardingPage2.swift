//
//  OnboardingPage2.swift
//  F1 Tracker
//

import SwiftUI

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
