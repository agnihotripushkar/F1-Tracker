//
//  ConstructorsStandingList.swift
//  F1 Tracker
//

import SwiftUI

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
            .background(StandingsTheme.row)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            // NEW ENTRY badge
            if constructor.isNewEntry {
                Text("NEW ENTRY")
                    .font(.system(size: 9, weight: .black))
                    .tracking(0.5)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(StandingsTheme.accent)
                    .clipShape(Capsule())
                    .padding(.top, 10)
                    .padding(.trailing, 14)
            }
        }
    }
}
