//
//  HomeView.swift
//  F1 Tracker
//

import SwiftUI
import Combine

// MARK: - Models

struct ScheduleSession: Identifiable {
    let id = UUID()
    let day: String
    let date: String
    let name: String
    let time: String
    let type: SessionType
}

enum SessionType { case past, upcoming, next, race }

// MARK: - Hardcoded data

private let scheduleItems: [ScheduleSession] = [
    ScheduleSession(day: "FRIDAY",   date: "MAR 22", name: "Practice 1", time: "18:30", type: .past),
    ScheduleSession(day: "FRIDAY",   date: "MAR 22", name: "Practice 2", time: "22:00", type: .past),
    ScheduleSession(day: "SATURDAY", date: "MAR 23", name: "Practice 3", time: "18:30", type: .past),
    ScheduleSession(day: "SATURDAY", date: "MAR 23", name: "Qualifying",  time: "22:00", type: .next),
    ScheduleSession(day: "SUNDAY",   date: "MAR 24", name: "Race Day",    time: "21:00", type: .race),
]

// Target: Qualifying on Saturday Mar 23 2026 22:00 UTC
private let qualifyingDate: Date = {
    var c = DateComponents()
    c.year = 2026; c.month = 3; c.day = 23
    c.hour = 22; c.minute = 0; c.second = 0
    c.timeZone = TimeZone(identifier: "UTC")
    return Calendar.current.date(from: c) ?? Date().addingTimeInterval(200_000)
}()

private let homeBg   = Color(red: 0.09, green: 0.09, blue: 0.09)
private let cardBg   = Color(red: 0.13, green: 0.13, blue: 0.13)
private let card2Bg  = Color(red: 0.11, green: 0.11, blue: 0.11)
private let cyanF1   = Color(red: 0.0,  green: 0.87, blue: 0.97)
private let redF1    = Color(red: 0.95, green: 0.10, blue: 0.10)

// MARK: - HomeView

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @State private var timeRemaining: TimeInterval = max(qualifyingDate.timeIntervalSinceNow, 0)
    @State private var colonVisible = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(repo: any F1RepositoryProtocol) {
        _viewModel = State(initialValue: HomeViewModel(repo: repo))
    }

    /// Use the live next-session date from the ViewModel when available;
    /// fall back to the hardcoded qualifying date while data is loading.
    private var countdownTarget: Date {
        viewModel.nextSession?.date ?? qualifyingDate
    }

    private var nextSessionLabel: String {
        viewModel.nextSession.map { "NEXT SESSION: \($0.name.uppercased())" }
            ?? "NEXT SESSION: QUALIFYING"
    }

    private var days:    Int { Int(timeRemaining) / 86400 }
    private var hours:   Int { (Int(timeRemaining) % 86400) / 3600 }
    private var minutes: Int { (Int(timeRemaining) % 3600) / 60 }

    var body: some View {
        ZStack {
            homeBg.ignoresSafeArea()
            DotGridBackground().ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    countdownSection
                    trackCard
                    weatherRow
                    scheduleCard
                    liveActivityButton
                        .padding(.bottom, 110)
                }
                .padding(.top, 56)
                .padding(.horizontal, 16)
            }
        }
        .task { await viewModel.load() }
        .onReceive(timer) { _ in
            timeRemaining = max(countdownTarget.timeIntervalSinceNow, 0)
            withAnimation(.easeInOut(duration: 0.3)) { colonVisible.toggle() }
        }
        .onChange(of: viewModel.nextSession?.date) { _, newDate in
            // Re-sync immediately whenever the live date arrives
            if let newDate {
                timeRemaining = max(newDate.timeIntervalSinceNow, 0)
            }
        }
    }

    // MARK: – Countdown

    private var countdownSection: some View {
        VStack(spacing: 8) {
            Text(nextSessionLabel)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .tracking(2)
                .foregroundColor(Color(white: 0.45))

            HStack(spacing: 4) {
                countUnit(String(format: "%02d", days))
                colon
                countUnit(String(format: "%02d", hours))
                colon
                countUnit(String(format: "%02d", minutes))
            }

            HStack(spacing: 0) {
                Text("DAYS")
                    .frame(width: 80, alignment: .center)
                Text("HOURS")
                    .frame(width: 80, alignment: .center)
                Text("MINS")
                    .frame(width: 80, alignment: .center)
            }
            .font(.system(size: 11, weight: .semibold, design: .monospaced))
            .tracking(2)
            .foregroundColor(Color(white: 0.40))
            .padding(.top, 2)
        }
        .padding(.bottom, 4)
    }

    private func countUnit(_ value: String) -> some View {
        Text(value)
            .font(.system(size: 64, weight: .black, design: .monospaced))
            .foregroundColor(redF1)
            .shadow(color: redF1.opacity(0.6), radius: 8, x: 0, y: 0)
            .frame(width: 80)
    }

    private var colon: some View {
        Text(":")
            .font(.system(size: 58, weight: .black, design: .monospaced))
            .foregroundColor(redF1)
            .opacity(colonVisible ? 1 : 0.2)
            .frame(width: 20)
    }

    // MARK: – Track card

    private var trackCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ALBERT PARK")
                        .font(.system(size: 26, weight: .black))
                        .italic()
                        .foregroundColor(.white)
                    Text("MELBOURNE, AUSTRALIA")
                        .font(.system(size: 12, weight: .bold))
                        .tracking(1)
                        .foregroundColor(cyanF1)
                }
                Spacer()
                Text("ROUND 3")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(white: 0.75))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Color(white: 0.22))
                    .clipShape(Capsule())
            }
            .padding([.top, .horizontal], 18)

            // Track outline
            ZStack {
                AlbertParkTrack()
                    .stroke(
                        cyanF1,
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
                    )
                    .shadow(color: cyanF1.opacity(0.7), radius: 6, x: 0, y: 0)

                // Start/finish red dot
                GeometryReader { geo in
                    Circle()
                        .fill(redF1)
                        .frame(width: 10, height: 10)
                        .shadow(color: redF1.opacity(0.8), radius: 5)
                        .position(x: geo.size.width * 0.265, y: geo.size.height * 0.76)
                }
            }
            .frame(height: 200)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            // Stats row
            HStack(spacing: 8) {
                trackStat(label: "LAP RECORD", value: "1:20.235")
                trackStat(label: "TURNS",      value: "14")
                trackStat(label: "DRS ZONES",  value: "4")
            }
            .padding([.horizontal, .bottom], 14)
        }
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func trackStat(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.system(size: 9, weight: .semibold))
                .tracking(1)
                .foregroundColor(Color(white: 0.45))
            Text(value)
                .font(.system(size: 20, weight: .black, design: .monospaced))
                .italic()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(white: 0.10))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: – Weather row

    private var weatherRow: some View {
        HStack(spacing: 12) {
            weatherCard(
                label: "AIR TEMP",
                value: viewModel.weather?.formattedAirTemp   ?? "—",
                icon: viewModel.weather?.isWet == true ? "cloud.rain.fill" : "sun.max.fill",
                iconColor: cyanF1
            )
            weatherCard(
                label: "TRACK TEMP",
                value: viewModel.weather?.formattedTrackTemp ?? "—",
                icon: "thermometer.medium",
                iconColor: redF1
            )
        }
    }

    private func weatherCard(label: String, value: String, icon: String, iconColor: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundColor(Color(white: 0.45))
                Text(value)
                    .font(.system(size: 32, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
            }
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(iconColor)
                .opacity(0.85)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: – Weekend schedule

    private var scheduleCard: some View {
        VStack(spacing: 0) {
            HStack {
                Text("WEEKEND SCHEDULE")
                    .font(.system(size: 16, weight: .black))
                    .italic()
                    .foregroundColor(.white)
                Spacer()
                Text("PDT (Fullerton, CA)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(Color(white: 0.55))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(white: 0.18))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 16)

            // Timeline
            VStack(spacing: 0) {
                ForEach(Array(scheduleItems.enumerated()), id: \.element.id) { idx, session in
                    ScheduleRow(session: session, isLast: idx == scheduleItems.count - 1)
                }
            }
            .padding(.bottom, 10)
        }
        .background(cardBg)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: – Live Activity button

    private var liveActivityButton: some View {
        Button { } label: {
            HStack(spacing: 14) {
                // Toggle icon
                Capsule()
                    .fill(Color(red: 0.85, green: 0.15, blue: 0.15))
                    .frame(width: 40, height: 24)
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 18, height: 18)
                            .offset(x: 8),
                        alignment: .leading
                    )
                    .padding(.leading, 2)

                Text("START LIVE ACTIVITY")
                    .font(.system(size: 16, weight: .black))
                    .tracking(0.5)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}

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

#Preview {
    HomeView()
}
