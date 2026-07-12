//
//  DotGridBackground.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Dot grid background

struct DotGridBackground: View {
    var body: some View {
        Canvas { ctx, size in
            let spacing: CGFloat = 22
            let dotSize: CGFloat = 1.2
            var x: CGFloat = spacing
            while x < size.width {
                var y: CGFloat = spacing
                while y < size.height {
                    let dot = Path(ellipseIn: CGRect(x: x, y: y, width: dotSize, height: dotSize))
                    ctx.fill(dot, with: .color(Color(white: 1.0, opacity: 0.05)))
                    y += spacing
                }
                x += spacing
            }
        }
    }
}
