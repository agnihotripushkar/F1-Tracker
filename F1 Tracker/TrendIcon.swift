//
//  TrendIcon.swift
//  F1 Tracker
//

import SwiftUI

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
