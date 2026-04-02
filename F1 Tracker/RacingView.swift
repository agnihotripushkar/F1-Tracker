//
//  RacingView.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Models

enum TireCompound {
    case soft, medium, hard

    var letter: String {
        switch self { case .soft: return "S"; case .medium: return "M"; case .hard: return "H" }
    }

    var color: Color {
        switch self {
        case .soft:   return Color(red: 0.92, green: 0.12, blue: 0.12)
        case .medium: return Color(red: 0.95, green: 0.75, blue: 0.0)
        case .hard:   return Color(white: 0.88)
        }
    }
}

struct LiveDriver: Identifiable {
    let id = UUID()
    let position: Int
    let lastName: String
    let abbrev: String
    let team: String
    let teamShort: String
    let teamColor: Color
    let interval: String
    let isLeader: Bool
    let tire: TireCompound
    let tireLaps: Int
    let pits: Int
}

private let racingBg    = Color(red: 0.07, green: 0.04, blue: 0.02)
private let rowBg       = Color(red: 0.11, green: 0.07, blue: 0.03)
private let rowBgAlt    = Color(red: 0.09, green: 0.055, blue: 0.025)
private let f1Orange    = Color(red: 1.0,  green: 0.38, blue: 0.0)

// MARK: - Main View

struct RacingView: View {
    @State private var viewModel: RacingViewModel
    @State private var activeSubTab: RacingSubTab = .leaderboard
    @State private var greenPulse = false

    init(repo: any F1RepositoryProtocol) {
        _viewModel = State(initialValue: RacingViewModel(repo: repo))
    }

    enum RacingSubTab: String, CaseIterable {
        case leaderboard = "LEADERBOARD"
        case telemetry   = "TELEMETRY"
        case radio       = "RADIO"
        case strategy    = "STRATEGY"
    }

    /// Map live F1TimingEntry → LiveDriver for the existing row components.
    private var displayDrivers: [LiveDriver] {
        viewModel.timingEntries.map { entry in
            LiveDriver(
                position:  entry.position,
                lastName:  entry.name.split(separator: " ").last.map(String.init) ?? entry.acronym,
                abbrev:    entry.acronym,
                team:      entry.teamName.uppercased(),
                teamShort: entry.teamName.uppercased(),
                teamColor: Color(hex: entry.teamColorHex),
                interval:  entry.isLeader ? "LEADER" : entry.gapToLeader,
                isLeader:  entry.isLeader,
                tire:      .hard,   // tire data requires a separate OpenF1 endpoint
                tireLaps:  0,
                pits:      0
            )
        }
    }

    var body: some View {
        ZStack {
            racingBg.ignoresSafeArea()

            VStack(spacing: 0) {
                raceHeader
                statusBanner
                subTabBar
                columnHeaders
                leaderboardList
            }
        }
        .onAppear  { viewModel.startPolling() }
        .onDisappear { viewModel.stopPolling() }
        .overlay(alignment: .top) {
            if viewModel.isDataStale {
                Text("DATA STALE")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.yellow)
                    .clipShape(Capsule())
                    .padding(.top, 56)
            }
        }
    }

    // MARK: – Race header
    private var raceHeader: some View {
        HStack(spacing: 0) {
            Button { } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(f1Orange)
                    .padding(.trailing, 8)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("LIVE TIMING")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1)
                    .foregroundColor(f1Orange)
                Text(raceSubtitle)
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.white)
            }

            Spacer()

            Button { } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 38, height: 38)
                    .background(Color(white: 0.18))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 52)
        .padding(.bottom, 14)
    }

    // MARK: – Green flag banner
    private var statusBanner: some View {
        HStack(spacing: 12) {
            // Pulsing green dot
            ZStack {
                Circle()
                    .fill(Color(red: 0.0, green: 0.85, blue: 0.55).opacity(0.3))
                    .frame(width: 20, height: 20)
                    .scaleEffect(greenPulse ? 1.6 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: greenPulse)
                Circle()
                    .fill(Color(red: 0.0, green: 0.85, blue: 0.55))
                    .frame(width: 10, height: 10)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(statusTitle)
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(Color(red: 0.0, green: 0.90, blue: 0.65))
                Text(statusSubtitle)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(Color(white: 0.55))
            }

            Spacer()

            Button { } label: {
                Text("TRACK MAP")
                    .font(.system(size: 11, weight: .black))
                    .tracking(0.5)
                    .foregroundColor(.black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color(red: 0.0, green: 0.90, blue: 0.65))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.04, green: 0.12, blue: 0.09))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.0, green: 0.5, blue: 0.35).opacity(0.6), lineWidth: 1)
                )
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 16)
        .onAppear { greenPulse = true }
    }

    // MARK: – Sub-tab bar
    private var subTabBar: some View {
        HStack(spacing: 0) {
            ForEach(RacingSubTab.allCases, id: \.self) { tab in
                let isActive = activeSubTab == tab
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) { activeSubTab = tab }
                } label: {
                    VStack(spacing: 0) {
                        Text(tab.rawValue)
                            .font(.system(size: 12, weight: .bold))
                            .tracking(0.5)
                            .foregroundColor(isActive ? f1Orange : Color(white: 0.45))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                        Rectangle()
                            .fill(isActive ? f1Orange : Color.clear)
                            .frame(height: 2)
                    }
                }
            }
        }
        .background(Color(red: 0.09, green: 0.06, blue: 0.03))
    }

    // MARK: – Column headers
    private var columnHeaders: some View {
        HStack(spacing: 0) {
            Text("POS")
                .frame(width: 42, alignment: .leading)
            Text("DRIVER")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("INTERVAL")
                .frame(width: 78, alignment: .trailing)
            Text("TIRE")
                .frame(width: 44, alignment: .center)
            Text("PITS")
                .frame(width: 36, alignment: .center)
        }
        .font(.system(size: 10, weight: .bold))
        .tracking(0.5)
        .foregroundColor(Color(white: 0.40))
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color(red: 0.06, green: 0.035, blue: 0.015))
    }

    // MARK: – Leaderboard list
    private var leaderboardList: some View {
        ScrollView(showsIndicators: false) {
            if displayDrivers.isEmpty {
                VStack(spacing: 12) {
                    Text(viewModel.isLoading ? "Loading live timing..." : "No live timing data available.")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Text("This screen only renders API data now. When OpenF1 has an active session, the leaderboard will populate here.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(white: 0.6))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 36)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(displayDrivers) { driver in
                        if driver.position <= 10 {
                            DetailedDriverRow(driver: driver)
                        } else {
                            CompactDriverRow(driver: driver)
                        }
                        Divider()
                            .background(Color(white: 0.10))
                    }
                }
                .padding(.bottom, 100)
            }
        }
    }

    private var raceSubtitle: String {
        if let lastUpdated = viewModel.lastUpdated {
            return "OPENF1 LIVE FEED • \(lastUpdated.formatted(.dateTime.hour().minute().second()))"
        }
        return "WAITING FOR LIVE SESSION"
    }

    private var statusTitle: String {
        viewModel.isLive ? "LIVE SESSION DETECTED" : "NO ACTIVE SESSION"
    }

    private var statusSubtitle: String {
        if let error = viewModel.error, !error.isEmpty {
            return error.uppercased()
        }
        if viewModel.isLive {
            return "POSITIONS ARE STREAMING FROM OPENF1"
        }
        return "NO API BACKFILL OR MOCK LEADERBOARD IS SHOWN"
    }
}

// MARK: - Detailed row (positions 1–10)

struct DetailedDriverRow: View {
    let driver: LiveDriver

    var body: some View {
        HStack(spacing: 0) {
            // Left orange accent for leader
            Rectangle()
                .fill(driver.isLeader ? f1Orange : Color.clear)
                .frame(width: 3)

            HStack(spacing: 0) {
                // Position
                Text("\(driver.position)")
                    .font(.system(size: 22, weight: .black, design: .default))
                    .italic()
                    .foregroundColor(.white)
                    .frame(width: 36, alignment: .leading)

                // Team color bar + name block
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(driver.teamColor)
                        .frame(width: 3, height: 36)
                        .clipShape(Capsule())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(driver.lastName)
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(.white)
                        Text(driver.team)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color(white: 0.45))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Interval
                Text(driver.interval)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(driver.isLeader ? f1Orange : Color(white: 0.80))
                    .frame(width: 78, alignment: .trailing)

                // Tire column
                VStack(spacing: 2) {
                    Circle()
                        .fill(driver.tire.color)
                        .frame(width: 18, height: 18)
                    Text("\(driver.tireLaps)L")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color(white: 0.50))
                }
                .frame(width: 44)

                // Pits
                Text("\(driver.pits)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(white: 0.70))
                    .frame(width: 36, alignment: .center)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
        .background(driver.position % 2 == 0 ? rowBgAlt : rowBg)
    }
}

// MARK: - Compact row (positions 11–20)

struct CompactDriverRow: View {
    let driver: LiveDriver

    var body: some View {
        HStack(spacing: 0) {
            // Position
            Text("\(driver.position)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color(white: 0.55))
                .frame(width: 32, alignment: .leading)
                .padding(.leading, 15)

            // Abbrev – Team
            Text("\(driver.abbrev)  –  \(driver.teamShort)")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color(white: 0.75))
                .frame(maxWidth: .infinity, alignment: .leading)

            // Interval
            Text(driver.interval)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(white: 0.70))
                .frame(width: 70, alignment: .trailing)

            // Tire letter
            Text(driver.tire.letter)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(driver.tire.color)
                .frame(width: 44, alignment: .center)

            // Pits
            Text("\(driver.pits)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(white: 0.60))
                .frame(width: 36, alignment: .center)
        }
        .padding(.vertical, 11)
        .background(driver.position % 2 == 0 ? rowBgAlt : rowBg)
    }
}

#Preview {
    RacingView(repo: AppDependencies.preview.repository)
}
