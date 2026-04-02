// F1DomainModels.swift
// Domain layer — pure Swift value types.
// NO SwiftData, NO URLSession, NO framework imports beyond Foundation.
// These are the only types the Presentation layer ever touches.

import Foundation

// MARK: - Driver Championship

struct F1DriverStanding: Identifiable, Sendable, Hashable {
    let id: String          // Jolpica driverId  e.g. "max_verstappen"
    let position: Int
    let points: Double
    let wins: Int
    let givenName: String
    let familyName: String
    let code: String        // e.g. "VER"
    let teamName: String
    let teamId: String      // Jolpica constructorId, used for color/logo lookup

    var fullName: String { "\(givenName) \(familyName)" }
}

// MARK: - Constructor Championship

struct F1ConstructorStanding: Identifiable, Sendable, Hashable {
    let id: String          // Jolpica constructorId  e.g. "red_bull"
    let position: Int
    let points: Double
    let wins: Int
    let name: String
}

// MARK: - Race Calendar

struct F1Race: Identifiable, Sendable {
    let id: Int             // round number
    let season: Int
    let raceName: String
    let circuitName: String
    let country: String
    let locality: String
    let raceDate: Date
    let qualifyingDate: Date?
    let fp1Date: Date?
    let fp2Date: Date?
    let fp3Date: Date?
    let sprintDate: Date?

    var isUpcoming: Bool { raceDate > .now }

    /// The soonest future session in this race weekend (name + target date).
    var nextSession: (name: String, date: Date)? {
        let candidates: [(String, Date?)] = [
            ("Practice 1", fp1Date),
            ("Practice 2", fp2Date),
            ("Practice 3", fp3Date),
            ("Qualifying",  qualifyingDate),
            ("Sprint",      sprintDate),
            ("Race",        raceDate)
        ]
        return candidates
            .compactMap { name, date in date.map { (name, $0) } }
            .filter { $0.1 > .now }
            .min { $0.1 < $1.1 }
    }

    /// All sessions in chronological order with their type tag.
    var allSessions: [(name: String, date: Date, isRace: Bool)] {
        let pairs: [(String, Date?, Bool)] = [
            ("Practice 1", fp1Date,        false),
            ("Practice 2", fp2Date,        false),
            ("Practice 3", fp3Date,        false),
            ("Sprint",     sprintDate,     false),
            ("Qualifying", qualifyingDate, false),
            ("Race Day",   raceDate,       true)
        ]
        return pairs.compactMap { name, date, isRace in
            date.map { (name, $0, isRace) }
        }.sorted { $0.date < $1.date }
    }
}

// MARK: - Weather

struct F1Weather: Sendable {
    let airTemp: Double
    let trackTemp: Double
    let humidity: Double
    let rainfall: Double
    let windSpeed: Double

    var isWet: Bool { rainfall > 0 }
    var formattedAirTemp:   String { "\(Int(airTemp.rounded()))°C" }
    var formattedTrackTemp: String { "\(Int(trackTemp.rounded()))°C" }
}

// MARK: - Live Timing

struct F1TimingEntry: Identifiable, Sendable {
    let id: Int             // driver number
    let position: Int
    let driverNumber: Int
    let name: String
    let acronym: String
    let teamName: String
    let teamColorHex: String   // 6-char hex from OpenF1, e.g. "E8002D"
    let gapToLeader: String
    let interval: String

    var isLeader: Bool { position == 1 }
}
