//
//  HomeView.swift
//  F1 Tracker
//

import SwiftUI
import Combine

// MARK: - Models

struct ScheduleSession: Identifiable {
    let id: String
    let day: String
    let date: String
    let name: String
    let time: String
    let type: SessionType
}

enum SessionType { case past, upcoming, next, race }

private let homeBg   = Color(red: 0.09, green: 0.09, blue: 0.09)
private let cardBg   = Color(red: 0.13, green: 0.13, blue: 0.13)
private let card2Bg  = Color(red: 0.11, green: 0.11, blue: 0.11)
private let cyanF1   = Color(red: 0.0,  green: 0.87, blue: 0.97)
private let redF1    = Color(red: 0.95, green: 0.10, blue: 0.10)

// MARK: - HomeView

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @State private var timeRemaining: TimeInterval = 0
    @State private var colonVisible = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(repo: any F1RepositoryProtocol) {
        _viewModel = State(initialValue: HomeViewModel(repo: repo))
    }

    private var nextSessionLabel: String {
        viewModel.nextSession.map { "NEXT SESSION: \($0.name.uppercased())" }
            ?? "NEXT SESSION UNAVAILABLE"
    }

    private var days:    Int { Int(timeRemaining) / 86400 }
    private var hours:   Int { (Int(timeRemaining) % 86400) / 3600 }
    private var minutes: Int { (Int(timeRemaining) % 3600) / 60 }

    private var scheduleItems: [ScheduleSession] {
        guard let race = viewModel.nextRace else { return [] }
        return race.allSessions.map { session in
            ScheduleSession(
                id: "\(race.id)-\(session.name)-\(session.date.timeIntervalSince1970)",
                day: session.date.formatted(.dateTime.weekday(.wide)).uppercased(),
                date: session.date.formatted(.dateTime.month(.abbreviated).day()),
                name: session.name,
                time: session.date.formatted(.dateTime.hour().minute()),
                type: sessionType(for: session.date, isRace: session.isRace)
            )
        }
    }

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
            timeRemaining = max(viewModel.nextSession?.date.timeIntervalSinceNow ?? 0, 0)
            withAnimation(.easeInOut(duration: 0.3)) { colonVisible.toggle() }
        }
        .onChange(of: viewModel.nextSession?.date) { _, newDate in
            timeRemaining = max(newDate?.timeIntervalSinceNow ?? 0, 0)
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
                    Text(viewModel.nextRace?.circuitName.uppercased() ?? "TRACK DATA UNAVAILABLE")
                        .font(.system(size: 26, weight: .black))
                        .italic()
                        .foregroundColor(.white)
                    Text(trackLocationText)
                        .font(.system(size: 12, weight: .bold))
                        .tracking(1)
                        .foregroundColor(cyanF1)
                }
                Spacer()
                Text(viewModel.nextRace.map { "ROUND \($0.id)" } ?? "NO DATA")
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
                trackStat(label: "LAP RECORD", value: "N/A")
                trackStat(label: "TURNS",      value: "N/A")
                trackStat(label: "DRS ZONES",  value: "N/A")
            }
            .padding([.horizontal, .bottom], 14)

            Text("TRACK OUTLINE IS ILLUSTRATIVE AND NOT API-SOURCED")
                .font(.system(size: 10, weight: .bold))
                .tracking(1)
                .foregroundColor(Color(white: 0.5))
                .padding(.horizontal, 18)
                .padding(.bottom, 16)
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
                Text(timezoneLabel)
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
                if scheduleItems.isEmpty {
                    Text(viewModel.isLoading ? "Loading schedule..." : "Weekend schedule unavailable.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(white: 0.55))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 18)
                        .padding(.bottom, 18)
                } else {
                    ForEach(Array(scheduleItems.enumerated()), id: \.element.id) { idx, session in
                        ScheduleRow(session: session, isLast: idx == scheduleItems.count - 1)
                    }
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

    private var trackLocationText: String {
        guard let race = viewModel.nextRace else { return "LIVE LOCATION UNAVAILABLE" }
        return "\(race.locality.uppercased()), \(race.country.uppercased())"
    }

    private func sessionType(for date: Date, isRace: Bool) -> SessionType {
        if isRace { return .race }
        if Calendar.current.isDate(date, equalTo: viewModel.nextSession?.date ?? .distantPast, toGranularity: .minute) {
            return .next
        }
        return date < .now ? .past : .upcoming
    }

    private var timezoneLabel: String {
        TimeZone.current.identifier.replacingOccurrences(of: "_", with: " ").uppercased()
    }
}

#Preview {
    HomeView(repo: AppDependencies.preview.repository)
}
