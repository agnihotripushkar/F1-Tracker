//
//  ScheduleRow.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Schedule row

struct ScheduleRow: View {
    let session: ScheduleSession
    let isLast: Bool

    private var dotColor: Color {
        switch session.type {
        case .past:     return Color(white: 0.35)
        case .upcoming: return Color(white: 0.35)
        case .next:     return Color(red: 0.95, green: 0.10, blue: 0.10)
        case .race:     return Color(red: 0.0,  green: 0.87, blue: 0.97)
        }
    }

    private var dateColor: Color {
        switch session.type {
        case .next: return Color(red: 0.95, green: 0.10, blue: 0.10)
        case .race: return Color(red: 0.0,  green: 0.87, blue: 0.97)
        default:    return Color(white: 0.45)
        }
    }

    private var timeColor: Color {
        session.type == .next ? Color(red: 0.95, green: 0.10, blue: 0.10) : .white
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // Timeline column
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color(white: 0.25))
                    .frame(width: 1.5)
                    .frame(maxHeight: .infinity)
                    .opacity(session.type == .past ? 0.5 : 0)

                Circle()
                    .fill(dotColor)
                    .frame(width: 10, height: 10)

                Rectangle()
                    .fill(Color(white: 0.25))
                    .frame(width: 1.5)
                    .frame(maxHeight: .infinity)
                    .opacity(isLast ? 0 : 0.5)
            }
            .frame(width: 40)
            .padding(.leading, 18)

            // Session info
            VStack(alignment: .leading, spacing: 3) {
                Text("\(session.day)  –  \(session.date)")
                    .font(.system(size: 11, weight: .bold))
                    .tracking(0.5)
                    .foregroundColor(dateColor)
                Text(session.name)
                    .font(.system(size: 15, weight: .black))
                    .italic()
                    .foregroundColor(.white)
            }
            .padding(.leading, 12)
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(session.time)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(timeColor)
                .padding(.trailing, 18)
        }
        .frame(height: 64)
    }
}
