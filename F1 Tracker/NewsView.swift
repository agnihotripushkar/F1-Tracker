//
//  NewsView.swift
//  F1 Tracker
//

import SwiftUI

struct NewsView: View {
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.06, blue: 0.09)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("NEWS")
                    .font(.system(size: 28, weight: .black))
                    .tracking(4)
                    .foregroundColor(.white)
                Text("Coming Soon")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(Color(white: 0.4))
            }
        }
    }
}

#Preview {
    NewsView()
}
