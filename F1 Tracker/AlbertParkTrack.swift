//
//  AlbertParkTrack.swift
//  F1 Tracker
//

import SwiftUI

// MARK: - Albert Park track shape

struct AlbertParkTrack: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()

        // Start: bottom-left start/finish area
        p.move(to: CGPoint(x: w*0.265, y: h*0.755))

        // Hairpin left side going up
        p.addCurve(
            to:       CGPoint(x: w*0.10, y: h*0.48),
            control1: CGPoint(x: w*0.13, y: h*0.78),
            control2: CGPoint(x: w*0.06, y: h*0.65)
        )
        // Up the left side
        p.addCurve(
            to:       CGPoint(x: w*0.18, y: h*0.20),
            control1: CGPoint(x: w*0.09, y: h*0.36),
            control2: CGPoint(x: w*0.10, y: h*0.24)
        )
        // Top-left curve going right
        p.addCurve(
            to:       CGPoint(x: w*0.50, y: h*0.12),
            control1: CGPoint(x: w*0.28, y: h*0.14),
            control2: CGPoint(x: w*0.40, y: h*0.09)
        )
        // Top right arc
        p.addCurve(
            to:       CGPoint(x: w*0.82, y: h*0.30),
            control1: CGPoint(x: w*0.68, y: h*0.12),
            control2: CGPoint(x: w*0.88, y: h*0.17)
        )
        // Right side going down
        p.addCurve(
            to:       CGPoint(x: w*0.78, y: h*0.62),
            control1: CGPoint(x: w*0.88, y: h*0.44),
            control2: CGPoint(x: w*0.86, y: h*0.56)
        )
        // Bottom-right curve going left
        p.addCurve(
            to:       CGPoint(x: w*0.55, y: h*0.775),
            control1: CGPoint(x: w*0.76, y: h*0.78),
            control2: CGPoint(x: w*0.67, y: h*0.82)
        )
        // Bottom straight back to start
        p.addCurve(
            to:       CGPoint(x: w*0.265, y: h*0.755),
            control1: CGPoint(x: w*0.46,  y: h*0.775),
            control2: CGPoint(x: w*0.35,  y: h*0.755)
        )

        return p
    }
}
