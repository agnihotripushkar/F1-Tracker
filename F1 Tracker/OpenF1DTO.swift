// OpenF1DTO.swift
// Decodable response types for the OpenF1 API

import Foundation

struct OpenF1WeatherResponse: Decodable {
    let airTemperature: Double
    let trackTemperature: Double
    let humidity: Double
    let rainfall: Double
    let windSpeed: Double
    let sessionKey: Int
    let date: String

    enum CodingKeys: String, CodingKey {
        case airTemperature  = "air_temperature"
        case trackTemperature = "track_temperature"
        case humidity
        case rainfall
        case windSpeed       = "wind_speed"
        case sessionKey      = "session_key"
        case date
    }
}

struct OpenF1IntervalResponse: Decodable {
    let driverNumber: Int
    let gapToLeader: Double?
    let interval: Double?
    let sessionKey: Int
    let date: String

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case gapToLeader  = "gap_to_leader"
        case interval
        case sessionKey   = "session_key"
        case date
    }
}

struct OpenF1PositionResponse: Decodable {
    let driverNumber: Int
    let position: Int
    let sessionKey: Int
    let date: String

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case position
        case sessionKey   = "session_key"
        case date
    }
}

struct OpenF1DriverResponse: Decodable {
    let driverNumber: Int
    let fullName: String
    let nameAcronym: String
    let teamName: String?
    let teamColour: String?
    let sessionKey: Int

    enum CodingKeys: String, CodingKey {
        case driverNumber = "driver_number"
        case fullName     = "full_name"
        case nameAcronym  = "name_acronym"
        case teamName     = "team_name"
        case teamColour   = "team_colour"
        case sessionKey   = "session_key"
    }
}
