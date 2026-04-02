//
//  StandingsView.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Data Models

enum TrendMagnitude { case big, small, none }

struct DriverStanding: Identifiable {
    let id = UUID()
    let position: Int
    let name: String
    let team: String
    let teamColor: Color
    let points: Int
    let trendDirection: TrendDirection
    let trendMagnitude: TrendMagnitude
    let imageName: String?
}

enum TrendDirection { case up, down, same }

struct ConstructorStanding: Identifiable {
    let id = UUID()
    let position: Int
    let name: String
    let drivers: String
    let points: Int
    let teamColor: Color
    let logoSystemName: String
    let trendDirection: TrendDirection
    let trendMagnitude: TrendMagnitude
    let isNewEntry: Bool
}

// MARK: - Accent / brand color

private let f1Orange = Color(red: 1.0, green: 0.38, blue: 0.0)
private let bgColor  = Color(red: 0.07, green: 0.04, blue: 0.02)
private let rowColor = Color(red: 0.11, green: 0.07, blue: 0.04)

// MARK: - Team color / logo helpers (keyed by Jolpica constructorId)

private func f1TeamColor(for teamId: String) -> Color {
    switch teamId {
    case "ferrari":       return Color(red: 0.85, green: 0.07, blue: 0.07)
    case "red_bull":      return Color(red: 0.18, green: 0.28, blue: 0.78)
    case "mercedes":      return Color(red: 0.0,  green: 0.78, blue: 0.70)
    case "mclaren":       return Color(red: 1.0,  green: 0.48, blue: 0.0)
    case "aston_martin":  return Color(red: 0.0,  green: 0.55, blue: 0.30)
    case "alpine":        return Color(red: 0.07, green: 0.38, blue: 0.82)
    case "williams":      return Color(red: 0.0,  green: 0.53, blue: 0.82)
    case "haas":          return Color(red: 0.82, green: 0.10, blue: 0.10)
    case "rb", "alphatauri": return Color(red: 0.28, green: 0.42, blue: 0.82)
    case "kick_sauber", "sauber": return Color(red: 0.0, green: 0.72, blue: 0.30)
    case "audi":          return Color(red: 0.85, green: 0.85, blue: 0.85)
    default:              return Color(white: 0.50)
    }
}

private func f1TeamLogo(for teamId: String) -> String {
    switch teamId {
    case "ferrari":      return "shield.fill"
    case "red_bull":     return "circle.hexagongrid.fill"
    case "mercedes":     return "star.fill"
    case "mclaren":      return "triangle.fill"
    case "aston_martin": return "diamond.fill"
    default:             return "circle.fill"
    }
}

// MARK: - Main Standings View

struct StandingsView: View {
    @State private var selectedTab: StandingsTab = .constructors
    @State private var viewModel: StandingsViewModel

    init(repo: any F1RepositoryProtocol) {
        _viewModel = State(initialValue: StandingsViewModel(repo: repo))
    }

    enum StandingsTab { case drivers, constructors }

    private var displayDriverStandings: [DriverStanding] {
        viewModel.driverStandings.map { standing in
            DriverStanding(
                position:       standing.position,
                name:           standing.fullName,
                team:           standing.teamName,
                teamColor:      f1TeamColor(for: standing.teamId),
                points:         Int(standing.points),
                trendDirection: .same,
                trendMagnitude: .none,
                imageName:      nil
            )
        }
    }

    private var displayConstructorStandings: [ConstructorStanding] {
        viewModel.constructorStandings.map { standing in
            ConstructorStanding(
                position:       standing.position,
                name:           standing.name,
                drivers:        "—",
                points:         Int(standing.points),
                teamColor:      f1TeamColor(for: standing.id),
                logoSystemName: f1TeamLogo(for: standing.id),
                trendDirection: .same,
                trendMagnitude: .none,
                isNewEntry:     false
            )
        }
    }

    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                tabToggle
                subHeader
                if isShowingEmptyState {
                    standingsEmptyState
                } else if selectedTab == .drivers {
                    DriversStandingList(drivers: displayDriverStandings)
                } else {
                    ConstructorsStandingList(constructors: displayConstructorStandings)
                }
            }
        }
        .task { await viewModel.load() }
        .refreshable { await viewModel.refresh() }
        .overlay(alignment: .bottom) {
            if let error = viewModel.error {
                Text(error)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.85))
                    .clipShape(Capsule())
                    .padding(.bottom, 110)
            }
        }
    }

    // MARK: – Header
    private var header: some View {
        HStack(alignment: .center) {
            Button { } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("CHAMPIONSHIP")
                    .font(.system(size: 17, weight: .black, design: .default))
                    .italic()
                    .foregroundColor(.white)
                Text("LIVE API STANDINGS")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(2)
                    .foregroundColor(f1Orange)
            }

            Spacer()

            Button { } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 16)
    }

    // MARK: – Pill toggle
    private var tabToggle: some View {
        HStack(spacing: 0) {
            toggleButton("DRIVERS",      tab: .drivers)
            toggleButton("CONSTRUCTORS", tab: .constructors)
        }
        .background(Color(red: 0.14, green: 0.08, blue: 0.04))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }

    @ViewBuilder
    private func toggleButton(_ label: String, tab: StandingsTab) -> some View {
        let isActive = selectedTab == tab
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
        } label: {
            Text(label)
                .font(.system(size: 13, weight: .black))
                .tracking(1)
                .foregroundColor(isActive ? .white : Color(white: 0.45))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    isActive
                    ? f1Orange.clipShape(RoundedRectangle(cornerRadius: 12))
                    : Color.clear.clipShape(RoundedRectangle(cornerRadius: 12))
                )
        }
        .padding(4)
    }

    // MARK: – Sub-header
    private var subHeader: some View {
        let title = selectedTab == .drivers
            ? "DRIVERS WORLD\nCHAMPIONSHIP"
            : "CONSTRUCTORS WORLD\nCHAMPIONSHIP"
        return HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .tracking(1)
                .foregroundColor(Color(white: 0.60))
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            VStack(alignment: .trailing, spacing: 1) {
                Text("SOURCE")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundColor(f1Orange)
                Text("JOLPICA")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(f1Orange)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 14)
    }

    private var isShowingEmptyState: Bool {
        selectedTab == .drivers ? displayDriverStandings.isEmpty : displayConstructorStandings.isEmpty
    }

    private var standingsEmptyState: some View {
        VStack(spacing: 12) {
            Text(viewModel.isLoading ? "Loading standings..." : "No standings data available.")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            Text("This screen no longer falls back to sample championship tables.")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(white: 0.6))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
        .padding(.top, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

// MARK: - Constructors List

struct ConstructorsStandingList: View {
    let constructors: [ConstructorStanding]
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(constructors) { item in
                    ConstructorRow2026(constructor: item)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 100)
        }
    }
}

struct ConstructorRow2026: View {
    let constructor: ConstructorStanding

    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: 0) {
                // Left color bar
                Rectangle()
                    .fill(constructor.teamColor)
                    .frame(width: 4)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 10,
                            bottomLeadingRadius: 10
                        )
                    )

                HStack(spacing: 14) {
                    // Position
                    Text("\(constructor.position)")
                        .font(.system(size: 32, weight: .black, design: .default))
                        .italic()
                        .foregroundColor(.white)
                        .frame(width: 36, alignment: .center)

                    // Logo
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.15, green: 0.10, blue: 0.06))
                            .frame(width: 64, height: 64)
                        Image(systemName: constructor.logoSystemName)
                            .font(.system(size: 26))
                            .foregroundColor(constructor.teamColor)
                    }

                    // Name + drivers + trend
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text(constructor.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            TrendIcon(direction: constructor.trendDirection,
                                      magnitude: constructor.trendMagnitude)
                        }
                        Text(constructor.drivers)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(white: 0.50))
                    }

                    Spacer()

                    // Points
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("\(constructor.points)")
                            .font(.system(size: 28, weight: .black, design: .default))
                            .italic()
                            .foregroundColor(.white)
                        Text("POINTS")
                            .font(.system(size: 9, weight: .bold))
                            .tracking(0.5)
                            .foregroundColor(Color(white: 0.45))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 16)
            }
            .background(rowColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // NEW ENTRY badge
            if constructor.isNewEntry {
                Text("NEW ENTRY")
                    .font(.system(size: 9, weight: .black))
                    .tracking(0.5)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(f1Orange)
                    .clipShape(Capsule())
                    .padding(.top, 10)
                    .padding(.trailing, 14)
            }
        }
    }
}

// MARK: - Drivers List

struct DriversStandingList: View {
    let drivers: [DriverStanding]
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(drivers) { driver in
                    DriverRow2026(driver: driver)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 100)
        }
    }
}

struct DriverRow2026: View {
    let driver: DriverStanding

    var body: some View {
        HStack(spacing: 0) {
            // Left color bar
            Rectangle()
                .fill(driver.teamColor)
                .frame(width: 4)
                .clipShape(
                    .rect(
                        topLeadingRadius: 10,
                        bottomLeadingRadius: 10
                    )
                )

            HStack(spacing: 14) {
                // Position
                Text("\(driver.position)")
                    .font(.system(size: 32, weight: .black, design: .default))
                    .italic()
                    .foregroundColor(.white)
                    .frame(width: 36, alignment: .center)

                // Driver avatar placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.15, green: 0.10, blue: 0.06))
                        .frame(width: 64, height: 64)
                    Image(systemName: "person.fill")
                        .font(.system(size: 28))
                        .foregroundColor(driver.teamColor.opacity(0.8))
                }

                // Name, team, trend
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(driver.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        TrendIcon(direction: driver.trendDirection,
                                  magnitude: driver.trendMagnitude)
                    }
                    Text(driver.team)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(white: 0.50))
                }

                Spacer()

                // Points
                VStack(alignment: .trailing, spacing: 1) {
                    Text("\(driver.points)")
                        .font(.system(size: 28, weight: .black, design: .default))
                        .italic()
                        .foregroundColor(.white)
                    Text("POINTS")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(0.5)
                        .foregroundColor(Color(white: 0.45))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 16)
        }
        .background(rowColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Trend Icon

struct TrendIcon: View {
    let direction: TrendDirection
    let magnitude: TrendMagnitude

    private var color: Color {
        switch direction {
        case .up:   return Color(red: 0.15, green: 0.82, blue: 0.35)
        case .down: return Color(red: 0.90, green: 0.20, blue: 0.20)
        case .same: return Color(white: 0.50)
        }
    }

    var body: some View {
        switch direction {
        case .same:
            Image(systemName: "minus")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(color)
        case .up:
            if magnitude == .big {
                // Double chevron up
                Image(systemName: "chevron.up.2")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(color)
            } else {
                Image(systemName: "chevron.up")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(color)
            }
        case .down:
            if magnitude == .big {
                Image(systemName: "chevron.down.2")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(color)
            } else {
                Image(systemName: "chevron.down")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(color)
            }
        }
    }
}

#Preview {
    StandingsView(repo: AppDependencies.preview.repository)
}
