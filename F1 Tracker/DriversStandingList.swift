//
//  DriversStandingList.swift
//  F1 Tracker
//

import SwiftUI

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
        .background(StandingsTheme.row)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
