// F1SwiftDataModels.swift
// SwiftData persistent models for local caching

import SwiftData
import Foundation

@Model
final class CachedDriverStanding {
    @Attribute(.unique) var driverId: String
    var position: Int
    var points: Double
    var wins: Int
    var givenName: String
    var familyName: String
    var code: String
    var teamName: String
    var teamId: String
    var updatedAt: Date

    init(driverId: String, position: Int, points: Double, wins: Int,
         givenName: String, familyName: String, code: String,
         teamName: String, teamId: String) {
        self.driverId  = driverId
        self.position  = position
        self.points    = points
        self.wins      = wins
        self.givenName = givenName
        self.familyName = familyName
        self.code      = code
        self.teamName  = teamName
        self.teamId    = teamId
        self.updatedAt = .now
    }

    var fullName: String { "\(givenName) \(familyName)" }
}

@Model
final class CachedConstructorStanding {
    @Attribute(.unique) var constructorId: String
    var position: Int
    var points: Double
    var wins: Int
    var name: String
    var updatedAt: Date

    init(constructorId: String, position: Int, points: Double, wins: Int, name: String) {
        self.constructorId = constructorId
        self.position      = position
        self.points        = points
        self.wins          = wins
        self.name          = name
        self.updatedAt     = .now
    }
}

@Model
final class CachedRace {
    @Attribute(.unique) var round: Int
    var season: Int
    var raceName: String
    var circuitName: String
    var country: String
    var locality: String
    var raceDate: Date
    var qualifyingDate: Date?
    var fp1Date: Date?
    var fp2Date: Date?
    var fp3Date: Date?
    var sprintDate: Date?
    var updatedAt: Date

    init(round: Int, season: Int, raceName: String, circuitName: String,
         country: String, locality: String, raceDate: Date) {
        self.round        = round
        self.season       = season
        self.raceName     = raceName
        self.circuitName  = circuitName
        self.country      = country
        self.locality     = locality
        self.raceDate     = raceDate
        self.updatedAt    = .now
    }
}

@Model
final class CachedWeather {
    var sessionKey: Int
    var airTemperature: Double
    var trackTemperature: Double
    var humidity: Double
    var rainfall: Double
    var windSpeed: Double
    var updatedAt: Date

    init(sessionKey: Int, airTemperature: Double, trackTemperature: Double,
         humidity: Double, rainfall: Double, windSpeed: Double) {
        self.sessionKey       = sessionKey
        self.airTemperature   = airTemperature
        self.trackTemperature = trackTemperature
        self.humidity         = humidity
        self.rainfall         = rainfall
        self.windSpeed        = windSpeed
        self.updatedAt        = .now
    }
}
