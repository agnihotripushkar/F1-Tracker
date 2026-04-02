//
//  TeamsView.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Data Model

enum TeamType: String, CaseIterable {
    case manufacturer
    case customer
}

struct F1Team: Identifiable {
    let id = UUID()
    let name: String
    let teamColor: Color
    let driver1: String
    let driver2: String
    let logoSystemName: String
    let type: TeamType
}

// MARK: - Filter

enum TeamFilter: String, CaseIterable {
    case all = "ALL TEAMS"
    case manufacturer = "MANUFACTURER PARTNERS"
    case customer = "CUSTOMER TEAMS"
}

// MARK: - 2026 Teams Data

private let f1Teams: [F1Team] = [
    F1Team(name: "Scuderia Ferrari",
           teamColor: Color(red: 0.85, green: 0.07, blue: 0.07),
           driver1: "Lewis Hamilton",
           driver2: "Charles Leclerc",
           logoSystemName: "shield.fill",
           type: .manufacturer),
    F1Team(name: "Oracle Red Bull Racing",
           teamColor: Color(red: 0.18, green: 0.28, blue: 0.78),
           driver1: "Max Verstappen",
           driver2: "Yuki Tsunoda",
           logoSystemName: "circle.hexagongrid.fill",
           type: .manufacturer),
    F1Team(name: "Mercedes-AMG Petronas",
           teamColor: Color(red: 0.0, green: 0.78, blue: 0.70),
           driver1: "George Russell",
           driver2: "Andrea Kimi Antonelli",
           logoSystemName: "star.fill",
           type: .manufacturer),
    F1Team(name: "Audi F1 Team",
           teamColor: Color(red: 0.85, green: 0.85, blue: 0.85),
           driver1: "Nico Hülkenberg",
           driver2: "Gabriel Bortoleto",
           logoSystemName: "circle.fill",
           type: .manufacturer),
    F1Team(name: "McLaren Formula 1",
           teamColor: Color(red: 1.0, green: 0.48, blue: 0.0),
           driver1: "Lando Norris",
           driver2: "Oscar Piastri",
           logoSystemName: "triangle.fill",
           type: .customer),
    F1Team(name: "Aston Martin Honda",
           teamColor: Color(red: 0.0, green: 0.55, blue: 0.30),
           driver1: "Fernando Alonso",
           driver2: "Lance Stroll",
           logoSystemName: "diamond.fill",
           type: .customer),
    F1Team(name: "Alpine F1 Team",
           teamColor: Color(red: 0.0, green: 0.55, blue: 0.85),
           driver1: "Pierre Gasly",
           driver2: "Jack Doohan",
           logoSystemName: "bolt.fill",
           type: .customer),
    F1Team(name: "Visa Cash App RB",
           teamColor: Color(red: 0.25, green: 0.35, blue: 0.65),
           driver1: "Isack Hadjar",
           driver2: "Liam Lawson",
           logoSystemName: "flame.fill",
           type: .customer),
    F1Team(name: "MoneyGram Haas F1",
           teamColor: Color(red: 0.70, green: 0.70, blue: 0.70),
           driver1: "Esteban Ocon",
           driver2: "Oliver Bearman",
           logoSystemName: "hexagon.fill",
           type: .customer),
    F1Team(name: "Williams Racing",
           teamColor: Color(red: 0.0, green: 0.35, blue: 0.70),
           driver1: "Carlos Sainz",
           driver2: "Alexander Albon",
           logoSystemName: "square.fill",
           type: .customer),
]

// MARK: - Colors

private let teamsBg = Color(red: 0.07, green: 0.07, blue: 0.09)
private let teamCardBg = Color(red: 0.12, green: 0.12, blue: 0.14)
private let teamsOrange = Color(red: 1.0, green: 0.38, blue: 0.0)

// MARK: - Teams View

struct TeamsView: View {
    @State private var selectedFilter: TeamFilter = .all

    private var filteredTeams: [F1Team] {
        switch selectedFilter {
        case .all:
            return f1Teams
        case .manufacturer:
            return f1Teams.filter { $0.type == .manufacturer }
        case .customer:
            return f1Teams.filter { $0.type == .customer }
        }
    }

    var body: some View {
        ZStack {
            teamsBg.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                staticDataBanner
                filterTabs
                teamsList
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .center) {
            Button { } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("F1 2026 TEAMS")
                    .font(.system(size: 17, weight: .black))
                    .italic()
                    .foregroundColor(.white)
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

    // MARK: - Filter Tabs

    private var filterTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TeamFilter.allCases, id: \.self) { filter in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    } label: {
                        Text(filter.rawValue)
                            .font(.system(size: 11, weight: .bold))
                            .tracking(0.5)
                            .foregroundColor(selectedFilter == filter ? .white : Color(white: 0.50))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                selectedFilter == filter
                                    ? teamsOrange
                                    : Color(white: 0.15)
                            )
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 16)
    }

    // MARK: - Teams List

    private var teamsList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(filteredTeams) { team in
                    TeamCardView(team: team)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 100)
        }
    }

    private var staticDataBanner: some View {
        Text("STATIC TEAM GUIDE • NOT LIVE API DATA")
            .font(.system(size: 11, weight: .bold))
            .tracking(1)
            .foregroundColor(.black)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(teamsOrange)
            .clipShape(Capsule())
            .padding(.bottom, 14)
    }
}

// MARK: - Team Card

struct TeamCardView: View {
    let team: F1Team

    var body: some View {
        HStack(spacing: 0) {
            // Left color accent bar
            Rectangle()
                .fill(team.teamColor)
                .frame(width: 4)
                .clipShape(
                    .rect(
                        topLeadingRadius: 12,
                        bottomLeadingRadius: 12
                    )
                )

            HStack(spacing: 0) {
                // Team logo placeholder
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(white: 0.08))
                        .frame(width: 52, height: 52)
                    Image(systemName: team.logoSystemName)
                        .font(.system(size: 22))
                        .foregroundColor(team.teamColor)
                }
                .padding(.leading, 12)

                // Team name + drivers
                VStack(alignment: .leading, spacing: 6) {
                    Text(team.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    VStack(alignment: .leading, spacing: 3) {
                        driverRow(team.driver1)
                        driverRow(team.driver2)
                    }
                }
                .padding(.leading, 12)

                Spacer()

                // Car silhouette placeholder
                Image(systemName: "car.side.fill")
                    .font(.system(size: 36))
                    .foregroundColor(team.teamColor.opacity(0.25))
                    .padding(.trailing, 14)
            }
            .padding(.vertical, 14)
        }
        .background(teamCardBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func driverRow(_ name: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(team.teamColor.opacity(0.6))
                .frame(width: 6, height: 6)
            Text(name)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(Color(white: 0.55))
        }
    }
}

#Preview {
    TeamsView()
}
