//
//  PageDotsView.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Page Dots Indicator

struct PageDotsView: View {
    let current: Int
    let total: Int
    let activeColor: Color

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { i in
                if i == current {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(activeColor)
                        .frame(width: 28, height: 6)
                } else {
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
}
