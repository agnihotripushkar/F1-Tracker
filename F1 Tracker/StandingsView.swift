//
//  StandingsView.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Data Models

struct DriverStanding: Identifiable {
    let id = UUID()
    let position: Int
    let name: String
    let team: String
    let teamColor: Color
    let points: Int
    let trend: Trend
    let imageName: String?
}

struct ConstructorStanding: Identifiable {
    let id = UUID()
    let position: Int
    let positionChange: Trend
    let name: String
    let base: String
    let points: Int
    let teamColor: Color
    let logoSystemName: String
}

enum Trend {
    case up, down, same

    var icon: String {
        switch self {
        case .up: return "arrowtriangle.up.fill"
        case .down: return "arrowtriangle.down.fill"
        case .same: return "minus"
        }
    }

    var color: Color {
        switch self {
        case .up: return .green
        case .down: return Color(red: 0.9, green: 0.2, blue: 0.2)
        case .same: return Color(white: 0.55)
        }
    }
}

// MARK: - Hardcoded Data

private let driverStandings: [DriverStanding] = [
    DriverStanding(position: 1, name: "MAX VERSTAPPEN",  team: "RED BULL",  teamColor: Color(red: 0.19, green: 0.27, blue: 0.67), points: 255, trend: .same,  imageName: nil),
    DriverStanding(position: 2, name: "LANDO NORRIS",    team: "MCLAREN",   teamColor: Color(red: 1.0,  green: 0.55, blue: 0.0),  points: 189, trend: .up,    imageName: nil),
    DriverStanding(position: 3, name: "CARLOS SAINZ",    team: "FERRARI",   teamColor: Color(red: 0.9,  green: 0.1,  blue: 0.1),  points: 148, trend: .up,    imageName: nil),
    DriverStanding(position: 4, name: "CHARLES LECLERC", team: "FERRARI",   teamColor: Color(red: 0.9,  green: 0.1,  blue: 0.1),  points: 138, trend: .up,    imageName: nil),
    DriverStanding(position: 5, name: "OSCAR PIASTRI",   team: "MCLAREN",   teamColor: Color(red: 1.0,  green: 0.55, blue: 0.0),  points: 114, trend: .down,  imageName: nil),
    DriverStanding(position: 6, name: "GEORGE RUSSELL",  team: "MERCEDES",  teamColor: Color(red: 0.0,  green: 0.82, blue: 0.75), points: 111, trend: .same,  imageName: nil),
    DriverStanding(position: 7, name: "LEWIS HAMILTON",  team: "FERRARI",   teamColor: Color(red: 0.9,  green: 0.1,  blue: 0.1),  points: 85,  trend: .up,    imageName: nil),
    DriverStanding(position: 8, name: "SERGIO PEREZ",    team: "RED BULL",  teamColor: Color(red: 0.19, green: 0.27, blue: 0.67), points: 79,  trend: .down,  imageName: nil),
    DriverStanding(position: 9, name: "FERNANDO ALONSO", team: "ASTON MARTIN", teamColor: Color(red: 0.0, green: 0.55, blue: 0.38), points: 62, trend: .same, imageName: nil),
    DriverStanding(position: 10, name: "LANCE STROLL",   team: "ASTON MARTIN", teamColor: Color(red: 0.0, green: 0.55, blue: 0.38), points: 24, trend: .same, imageName: nil),
]

private let constructorStandings: [ConstructorStanding] = [
    ConstructorStanding(position: 1, positionChange: .same, name: "Oracle Red Bull Racing",    base: "MILTON KEYNES, UK",  points: 402, teamColor: Color(red: 0.19, green: 0.27, blue: 0.67), logoSystemName: "circle.hexagongrid.fill"),
    ConstructorStanding(position: 2, positionChange: .up,   name: "McLaren Formula 1 Team",   base: "WOKING, UK",         points: 338, teamColor: Color(red: 1.0,  green: 0.55, blue: 0.0),  logoSystemName: "triangle.fill"),
    ConstructorStanding(position: 3, positionChange: .down, name: "Scuderia Ferrari",         base: "MARANELLO, ITALY",   points: 322, teamColor: Color(red: 0.9,  green: 0.1,  blue: 0.1),  logoSystemName: "shield.fill"),
    ConstructorStanding(position: 4, positionChange: .same, name: "Mercedes-AMG Petronas",    base: "BRACKLEY, UK",       points: 266, teamColor: Color(red: 0.0,  green: 0.82, blue: 0.75), logoSystemName: "star.fill"),
    ConstructorStanding(position: 5, positionChange: .same, name: "Aston Martin Aramco",      base: "SILVERSTONE, UK",    points: 73,  teamColor: Color(red: 0.0,  green: 0.55, blue: 0.38), logoSystemName: "diamond.fill"),
    ConstructorStanding(position: 6, positionChange: .up,   name: "Visa Cash App RB",         base: "FAENZA, ITALY",      points: 34,  teamColor: Color(red: 0.3,  green: 0.5,  blue: 0.85), logoSystemName: "circle.fill"),
    ConstructorStanding(position: 7, positionChange: .down, name: "Haas F1 Team",             base: "KANNAPOLIS, USA",    points: 31,  teamColor: Color(red: 0.85, green: 0.85, blue: 0.85), logoSystemName: "hexagon.fill"),
    ConstructorStanding(position: 8, positionChange: .same, name: "Williams Racing",          base: "GROVE, UK",          points: 16,  teamColor: Color(red: 0.0,  green: 0.4,  blue: 0.85), logoSystemName: "bolt.fill"),
    ConstructorStanding(position: 9, positionChange: .same, name: "Kick Sauber",              base: "HINWIL, SWITZERLAND",points: 4,   teamColor: Color(red: 0.1,  green: 0.75, blue: 0.3),  logoSystemName: "plus.circle.fill"),
    ConstructorStanding(position: 10, positionChange: .same, name: "Alpine F1 Team",          base: "ENSTONE, UK",        points: 3,   teamColor: Color(red: 0.05, green: 0.35, blue: 0.85), logoSystemName: "arrow.up.circle.fill"),
]

// MARK: - Main Standings View

struct StandingsView: View {
    @State private var selectedTab: StandingsTab = .drivers

    enum StandingsTab { case drivers, constructors }

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.06, blue: 0.09)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                header

                // Toggle tabs
                tabSelector

                // Content
                if selectedTab == .drivers {
                    DriversStandingList()
                } else {
                    ConstructorsStandingList()
                }
            }
        }
    }

    // MARK: Header
    private var header: some View {
        HStack {
            Button { } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
            }

            Spacer()

            HStack(spacing: 6) {
                Text("STANDINGS")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(.white)
                Text("2025")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.0))
            }

            Spacer()

            Button { } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 56)
        .padding(.bottom, 14)
    }

    // MARK: Tab selector
    private var tabSelector: some View {
        HStack(spacing: 0) {
            tabButton("DRIVERS", tab: .drivers)
            tabButton("CONSTRUCTORS", tab: .constructors)
        }
        .background(Color(red: 0.08, green: 0.09, blue: 0.12))
    }

    @ViewBuilder
    private func tabButton(_ label: String, tab: StandingsTab) -> some View {
        let isSelected = selectedTab == tab
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
        } label: {
            VStack(spacing: 0) {
                Text(label)
                    .font(.system(size: 13, weight: .bold))
                    .tracking(1)
                    .foregroundColor(isSelected ? .white : Color(white: 0.45))
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(isSelected ? Color(red: 1.0, green: 0.4, blue: 0.0) : Color.clear)
                    .frame(height: 2)
            }
        }
    }
}

// MARK: - Drivers List

struct DriversStandingList: View {
    private let top3 = Array(driverStandings.prefix(3))
    private let rest  = Array(driverStandings.dropFirst(3))

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Podium
                PodiumView(drivers: top3)
                    .padding(.bottom, 16)

                // Remaining drivers
                VStack(spacing: 8) {
                    ForEach(rest) { driver in
                        DriverRow(driver: driver)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 100) // space for nav bar
            }
        }
    }
}

// MARK: - Podium

struct PodiumView: View {
    let drivers: [DriverStanding]

    var body: some View {
        ZStack {
            // subtle radial glow behind podium
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.4, blue: 0.0).opacity(0.12),
                    Color.clear
                ]),
                center: .center,
                startRadius: 10,
                endRadius: 200
            )
            .frame(height: 300)

            HStack(alignment: .bottom, spacing: 0) {
                // 2nd place
                PodiumCard(driver: drivers[1], rank: 2, size: .medium)
                // 1st place
                PodiumCard(driver: drivers[0], rank: 1, size: .large)
                // 3rd place
                PodiumCard(driver: drivers[2], rank: 3, size: .small)
            }
            .padding(.horizontal, 8)
        }
        .padding(.top, 16)
    }
}

enum PodiumSize { case large, medium, small }

struct PodiumCard: View {
    let driver: DriverStanding
    let rank: Int
    let size: PodiumSize

    private var avatarSize: CGFloat {
        switch size {
        case .large: return 90
        case .medium: return 74
        case .small: return 64
        }
    }

    private var ringColor: Color {
        switch size {
        case .large:  return Color(red: 1.0, green: 0.4, blue: 0.0)
        case .medium: return Color(white: 0.7)
        case .small:  return Color(red: 0.8, green: 0.55, blue: 0.15)
        }
    }

    private var barHeight: CGFloat {
        switch size {
        case .large: return 80
        case .medium: return 50
        case .small: return 30
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Trophy for P1
            if size == .large {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.0))
                    .padding(.bottom, 4)
            }

            // Avatar circle
            ZStack {
                Circle()
                    .stroke(ringColor, lineWidth: 3)
                    .frame(width: avatarSize, height: avatarSize)

                Circle()
                    .fill(Color(white: 0.15))
                    .frame(width: avatarSize - 8, height: avatarSize - 8)

                Image(systemName: "person.fill")
                    .font(.system(size: avatarSize * 0.4))
                    .foregroundColor(Color(white: 0.5))

                // Rank badge
                ZStack {
                    Circle()
                        .fill(ringColor)
                        .frame(width: 22, height: 22)
                    Text("\(rank)")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(.white)
                }
                .offset(x: avatarSize * 0.36, y: avatarSize * 0.36)
            }

            // Name + points
            VStack(spacing: 2) {
                Text(driver.name)
                    .font(.system(size: size == .large ? 11 : 9, weight: .bold))
                    .foregroundColor(Color(white: 0.65))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)

                Text("\(driver.points) PTS")
                    .font(.system(size: size == .large ? 14 : 11, weight: .black))
                    .foregroundColor(size == .large ? Color(red: 1.0, green: 0.4, blue: 0.0) : .white)
            }
            .padding(.top, 6)
            .frame(width: size == .large ? 110 : 90)

            // Podium bar
            RoundedRectangle(cornerRadius: 4)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [ringColor.opacity(0.7), ringColor.opacity(0.3)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: barHeight)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Driver Row

struct DriverRow: View {
    let driver: DriverStanding

    var body: some View {
        HStack(spacing: 12) {
            // Position
            Text("\(driver.position)")
                .font(.system(size: 22, weight: .black))
                .foregroundColor(Color(white: 0.4))
                .frame(width: 30)

            // Team color bar
            RoundedRectangle(cornerRadius: 2)
                .fill(driver.teamColor)
                .frame(width: 4, height: 38)

            // Name & team
            VStack(alignment: .leading, spacing: 2) {
                Text(driver.name)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(white: 0.85))
                    .lineLimit(1)
                Text(driver.team)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(white: 0.45))
            }

            Spacer()

            // Points
            HStack(spacing: 4) {
                Text("\(driver.points)")
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(.white)
                Text("PTS")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(Color(white: 0.45))
            }

            // Trend
            Image(systemName: driver.trend.icon)
                .font(.system(size: 10))
                .foregroundColor(driver.trend.color)
                .frame(width: 16)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(red: 0.10, green: 0.11, blue: 0.14))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Constructors List

struct ConstructorsStandingList: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(constructorStandings) { constructor in
                    ConstructorRow(constructor: constructor)
                    if constructor.position != constructorStandings.last?.position {
                        Divider()
                            .background(Color(white: 0.12))
                            .padding(.leading, 76)
                    }
                }
            }
            .padding(.bottom, 100)
        }
    }
}

struct ConstructorRow: View {
    let constructor: ConstructorStanding

    var body: some View {
        HStack(spacing: 14) {
            // Position + change
            VStack(spacing: 2) {
                Text("\(constructor.position)")
                    .font(.system(size: 20, weight: .black))
                    .foregroundColor(.white)
                Image(systemName: constructor.positionChange.icon)
                    .font(.system(size: 9))
                    .foregroundColor(constructor.positionChange.color)
            }
            .frame(width: 28)

            // Team color stripe
            RoundedRectangle(cornerRadius: 2)
                .fill(constructor.teamColor)
                .frame(width: 4, height: 52)

            // Team logo placeholder
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(white: 0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: constructor.logoSystemName)
                    .font(.system(size: 22))
                    .foregroundColor(constructor.teamColor)
            }

            // Team name + base
            VStack(alignment: .leading, spacing: 3) {
                Text(constructor.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                Text(constructor.base)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(white: 0.45))
            }

            Spacer()

            // Points
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(constructor.points)")
                    .font(.system(size: 22, weight: .black).italic())
                    .foregroundColor(.white)
                Text("POINTS")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(Color(white: 0.45))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    StandingsView()
}
