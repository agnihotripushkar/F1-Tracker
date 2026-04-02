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

// MARK: - Hardcoded race data (Australian GP, Lap 42/58)

private let liveDrivers: [LiveDriver] = [
    LiveDriver(position: 1,  lastName: "VERSTAPPEN", abbrev: "VER", team: "RED BULL RACING",  teamShort: "RED BULL",     teamColor: Color(red:0.18,green:0.28,blue:0.78), interval: "INTERVAL", isLeader: true,  tire: .soft,   tireLaps: 12, pits: 1),
    LiveDriver(position: 2,  lastName: "LECLERC",    abbrev: "LEC", team: "FERRARI",          teamShort: "FERRARI",      teamColor: Color(red:0.85,green:0.07,blue:0.07), interval: "+4.281",   isLeader: false, tire: .medium, tireLaps: 14, pits: 1),
    LiveDriver(position: 3,  lastName: "PEREZ",      abbrev: "PER", team: "RED BULL RACING",  teamShort: "RED BULL",     teamColor: Color(red:0.18,green:0.28,blue:0.78), interval: "+2.104",   isLeader: false, tire: .hard,   tireLaps: 18, pits: 1),
    LiveDriver(position: 4,  lastName: "RUSSELL",    abbrev: "RUS", team: "MERCEDES",         teamShort: "MERCEDES",     teamColor: Color(red:0.0, green:0.78,blue:0.70), interval: "+0.482",   isLeader: false, tire: .soft,   tireLaps: 4,  pits: 2),
    LiveDriver(position: 5,  lastName: "NORRIS",     abbrev: "NOR", team: "MCLAREN",          teamShort: "MCLAREN",      teamColor: Color(red:1.0, green:0.48,blue:0.0),  interval: "+0.315",   isLeader: false, tire: .soft,   tireLaps: 5,  pits: 2),
    LiveDriver(position: 6,  lastName: "SAINZ",      abbrev: "SAI", team: "FERRARI",          teamShort: "FERRARI",      teamColor: Color(red:0.85,green:0.07,blue:0.07), interval: "+8.922",   isLeader: false, tire: .hard,   tireLaps: 22, pits: 1),
    LiveDriver(position: 7,  lastName: "HAMILTON",   abbrev: "HAM", team: "MERCEDES",         teamShort: "MERCEDES",     teamColor: Color(red:0.0, green:0.78,blue:0.70), interval: "+1.505",   isLeader: false, tire: .medium, tireLaps: 10, pits: 2),
    LiveDriver(position: 8,  lastName: "PIASTRI",    abbrev: "PIA", team: "MCLAREN",          teamShort: "MCLAREN",      teamColor: Color(red:1.0, green:0.48,blue:0.0),  interval: "+12.440",  isLeader: false, tire: .hard,   tireLaps: 24, pits: 1),
    LiveDriver(position: 9,  lastName: "ALONSO",     abbrev: "ALO", team: "ASTON MARTIN",     teamShort: "ASTON MARTIN", teamColor: Color(red:0.0, green:0.55,blue:0.30), interval: "+0.988",   isLeader: false, tire: .soft,   tireLaps: 8,  pits: 2),
    LiveDriver(position: 10, lastName: "STROLL",     abbrev: "STR", team: "ASTON MARTIN",     teamShort: "ASTON MARTIN", teamColor: Color(red:0.0, green:0.55,blue:0.30), interval: "+4.552",   isLeader: false, tire: .medium, tireLaps: 15, pits: 1),
    LiveDriver(position: 11, lastName: "HÜLKENBERG", abbrev: "HUL", team: "HAAS",             teamShort: "HAAS",         teamColor: Color(red:0.8, green:0.8, blue:0.8),  interval: "+2.1s",    isLeader: false, tire: .hard,   tireLaps: 0,  pits: 1),
    LiveDriver(position: 12, lastName: "TSUNODA",    abbrev: "TSU", team: "VCARB",            teamShort: "VCARB",        teamColor: Color(red:0.2, green:0.4, blue:0.8),  interval: "+0.8s",    isLeader: false, tire: .medium, tireLaps: 0,  pits: 2),
    LiveDriver(position: 13, lastName: "ALBON",      abbrev: "ALB", team: "WILLIAMS",         teamShort: "WILLIAMS",     teamColor: Color(red:0.0, green:0.35,blue:0.75), interval: "+1.5s",    isLeader: false, tire: .hard,   tireLaps: 0,  pits: 1),
    LiveDriver(position: 14, lastName: "GASLY",      abbrev: "GAS", team: "ALPINE",           teamShort: "ALPINE",       teamColor: Color(red:0.0, green:0.35,blue:0.85), interval: "+5.2s",    isLeader: false, tire: .medium, tireLaps: 0,  pits: 2),
    LiveDriver(position: 15, lastName: "MAGNUSSEN",  abbrev: "MAG", team: "HAAS",             teamShort: "HAAS",         teamColor: Color(red:0.8, green:0.8, blue:0.8),  interval: "+0.4s",    isLeader: false, tire: .hard,   tireLaps: 0,  pits: 1),
    LiveDriver(position: 16, lastName: "RICCIARDO",  abbrev: "RIC", team: "VCARB",            teamShort: "VCARB",        teamColor: Color(red:0.2, green:0.4, blue:0.8),  interval: "+1.2s",    isLeader: false, tire: .medium, tireLaps: 0,  pits: 2),
    LiveDriver(position: 17, lastName: "ZHOU",       abbrev: "ZHO", team: "KICK SAUBER",      teamShort: "KICK SAUBER",  teamColor: Color(red:0.1, green:0.75,blue:0.3),  interval: "+3.1s",    isLeader: false, tire: .hard,   tireLaps: 0,  pits: 2),
    LiveDriver(position: 18, lastName: "BOTTAS",     abbrev: "BOT", team: "KICK SAUBER",      teamShort: "KICK SAUBER",  teamColor: Color(red:0.1, green:0.75,blue:0.3),  interval: "+0.5s",    isLeader: false, tire: .medium, tireLaps: 0,  pits: 2),
    LiveDriver(position: 19, lastName: "OCON",       abbrev: "OCO", team: "ALPINE",           teamShort: "ALPINE",       teamColor: Color(red:0.0, green:0.35,blue:0.85), interval: "+2.4s",    isLeader: false, tire: .hard,   tireLaps: 0,  pits: 2),
    LiveDriver(position: 20, lastName: "SARGEANT",   abbrev: "SAR", team: "WILLIAMS",         teamShort: "WILLIAMS",     teamColor: Color(red:0.0, green:0.35,blue:0.75), interval: "+6.1s",    isLeader: false, tire: .soft,   tireLaps: 0,  pits: 3),
]

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
    /// Falls back to hardcoded data when no live session is active.
    private var displayDrivers: [LiveDriver] {
        guard !viewModel.timingEntries.isEmpty else { return liveDrivers }
        return viewModel.timingEntries.map { entry in
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
                Text("AUSTRALIAN GRAND PRIX - LAP 42/58")
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
                Text("GREEN FLAG - RACING")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(Color(red: 0.0, green: 0.90, blue: 0.65))
                Text("TRACK CLEAR  •  SECTOR 1-3 ACTIVE")
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
    RacingView()
}
