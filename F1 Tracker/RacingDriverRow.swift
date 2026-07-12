//
//  RacingDriverRow.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Detailed row (positions 1–10)

struct DetailedDriverRow: View {
    let driver: LiveDriver

    var body: some View {
        HStack(spacing: 0) {
            // Left orange accent for leader
            Rectangle()
                .fill(driver.isLeader ? RacingTheme.accent : Color.clear)
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
                    .foregroundColor(driver.isLeader ? RacingTheme.accent : Color(white: 0.80))
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
        .background(driver.position % 2 == 0 ? RacingTheme.rowBackgroundAlt : RacingTheme.rowBackground)
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
        .background(driver.position % 2 == 0 ? RacingTheme.rowBackgroundAlt : RacingTheme.rowBackground)
    }
}
