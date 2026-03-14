//
//  MainTabView.swift
//  F1 Tracker
//

import SwiftUI

enum Tab: Int, CaseIterable {
    case home, racing, standings, teams, news

    var title: String {
        switch self {
        case .home: return "HOME"
        case .racing: return "RACING"
        case .standings: return "STANDINGS"
        case .teams: return "TEAMS"
        case .news: return "NEWS"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .racing: return "flag.fill"
        case .standings: return "chart.bar.fill"
        case .teams: return "person.3.fill"
        case .news: return "newspaper.fill"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .standings

    var body: some View {
        ZStack(alignment: .bottom) {
            // Page content
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .racing:
                    RacingView()
                case .standings:
                    StandingsView()
                case .teams:
                    TeamsView()
                case .news:
                    NewsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Bottom nav bar
            BottomNavBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BottomNavBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 22, weight: .medium))
                        Text(tab.title)
                            .font(.system(size: 9, weight: .semibold, design: .default))
                            .tracking(0.5)
                    }
                    .foregroundColor(selectedTab == tab ? Color(red: 1.0, green: 0.4, blue: 0.0) : Color(white: 0.55))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 12)
                    .padding(.bottom, 28) // extra space for home indicator
                }
            }
        }
        .background(
            Color(red: 0.08, green: 0.08, blue: 0.10)
                .overlay(
                    Rectangle()
                        .fill(Color.white.opacity(0.06))
                        .frame(height: 1),
                    alignment: .top
                )
        )
    }
}

#Preview {
    MainTabView()
}
