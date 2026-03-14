//
//  SplashScreenView.swift
//  F1 Tracker
//
//  Created by csuftitan on 3/11/26.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var animatingDots = false
    @State private var showMainApp = false

    var body: some View {
        if showMainApp {
            MainTabView()
        } else {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.05, green: 0.08, blue: 0.12),
                        Color(red: 0.08, green: 0.05, blue: 0.08),
                        Color(red: 0.05, green: 0.08, blue: 0.12)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    // F1 Logo
                    F1Logo()
                        .frame(width: 180, height: 180)

                    Spacer()
                        .frame(height: 80)

                    // "RACE READY" Text
                    Text("RACE READY")
                        .font(.system(size: 48, weight: .black, design: .default))
                        .tracking(8)
                        .foregroundColor(.white)

                    Spacer()
                        .frame(height: 20)

                    // Tagline with decorative lines
                    HStack(spacing: 15) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 40, height: 1)

                        Text("ANALYZE. OPTIMIZE. WIN.")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .tracking(3)
                            .foregroundColor(.gray)

                        Rectangle()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 40, height: 1)
                    }

                    Spacer()

                    // Loading dots
                    LoadingDots(animating: $animatingDots)
                        .padding(.bottom, 60)
                }
            }
            .onAppear {
                animatingDots = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showMainApp = true
                    }
                }
            }
        }
    }
}

struct F1Logo: View {
    var body: some View {
        ZStack {
            // Red glow effect
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.red.opacity(0.3),
                            Color.red.opacity(0.1),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)
            
            // F1 Logo
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                ZStack {
                    // Horizontal red line (top)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.red)
                        .frame(width: width * 0.8, height: 6)
                        .offset(y: -height * 0.15)
                    
                    // Vertical red line (right)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.red)
                        .frame(width: 6, height: height * 0.5)
                        .offset(x: width * 0.18, y: height * 0.025)
                    
                    // Letter "F" - simplified geometric shape
                    ZStack {
                        // Main vertical bar of F
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.4, green: 0.5, blue: 0.6),
                                        Color(red: 0.2, green: 0.3, blue: 0.4)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 35, height: 120)
                            .offset(x: -width * 0.12)
                        
                        // Top horizontal bar of F
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.4, green: 0.5, blue: 0.6),
                                        Color(red: 0.2, green: 0.3, blue: 0.4)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 28)
                            .offset(x: width * 0.02, y: -height * 0.23)
                        
                        // Middle horizontal bar of F
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.35, green: 0.45, blue: 0.55),
                                        Color(red: 0.2, green: 0.3, blue: 0.4)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 65, height: 28)
                            .offset(x: -width * 0.02, y: -height * 0.05)
                    }
                    .offset(y: height * 0.05)
                }
            }
        }
    }
}

struct LoadingDots: View {
    @Binding var animating: Bool
    @State private var dot1Scale: CGFloat = 1.0
    @State private var dot2Scale: CGFloat = 1.0
    @State private var dot3Scale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
                .scaleEffect(dot1Scale)
            
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
                .scaleEffect(dot2Scale)
            
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
                .scaleEffect(dot3Scale)
        }
        .onChange(of: animating) { _, newValue in
            if newValue {
                startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
            dot1Scale = 1.5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                dot2Scale = 1.5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                dot3Scale = 1.5
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
