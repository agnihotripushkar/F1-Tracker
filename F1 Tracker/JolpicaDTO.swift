// JolpicaDTO.swift
// Decodable response types for the Jolpica-F1 API (Ergast-compatible)

import Foundation

// MARK: - Driver Standings

struct JolpicaDriverStandingsResponse: Decodable {
    let mrData: MRData
    enum CodingKeys: String, CodingKey { case mrData = "MRData" }

    struct MRData: Decodable {
        let standingsTable: StandingsTable
        enum CodingKeys: String, CodingKey { case standingsTable = "StandingsTable" }
    }
    struct StandingsTable: Decodable {
        let standingsLists: [StandingsList]
        enum CodingKeys: String, CodingKey { case standingsLists = "StandingsLists" }
    }
    struct StandingsList: Decodable {
        let season: String
        let round: String
        let driverStandings: [DriverStanding]
        enum CodingKeys: String, CodingKey {
            case season, round
            case driverStandings = "DriverStandings"
        }
    }
    struct DriverStanding: Decodable {
        let position: String
        let points: String
        let wins: String
        let driver: Driver
        let constructors: [Constructor]
        enum CodingKeys: String, CodingKey {
            case position, points, wins
            case driver = "Driver"
            case constructors = "Constructors"
        }
    }
    struct Driver: Decodable {
        let driverId: String
        let permanentNumber: String?
        let code: String?
        let givenName: String
        let familyName: String
        let nationality: String
    }
    struct Constructor: Decodable {
        let constructorId: String
        let name: String
    }
}

// MARK: - Constructor Standings

struct JolpicaConstructorStandingsResponse: Decodable {
    let mrData: MRData
    enum CodingKeys: String, CodingKey { case mrData = "MRData" }

    struct MRData: Decodable {
        let standingsTable: StandingsTable
        enum CodingKeys: String, CodingKey { case standingsTable = "StandingsTable" }
    }
    struct StandingsTable: Decodable {
        let standingsLists: [StandingsList]
        enum CodingKeys: String, CodingKey { case standingsLists = "StandingsLists" }
    }
    struct StandingsList: Decodable {
        let constructorStandings: [ConstructorStanding]
        enum CodingKeys: String, CodingKey { case constructorStandings = "ConstructorStandings" }
    }
    struct ConstructorStanding: Decodable {
        let position: String
        let points: String
        let wins: String
        let constructor: Constructor
        enum CodingKeys: String, CodingKey {
            case position, points, wins
            case constructor = "Constructor"
        }
    }
    struct Constructor: Decodable {
        let constructorId: String
        let name: String
    }
}

// MARK: - Race Schedule

struct JolpicaScheduleResponse: Decodable {
    let mrData: MRData
    enum CodingKeys: String, CodingKey { case mrData = "MRData" }

    struct MRData: Decodable {
        let raceTable: RaceTable
        enum CodingKeys: String, CodingKey { case raceTable = "RaceTable" }
    }
    struct RaceTable: Decodable {
        let season: String
        let races: [Race]
        enum CodingKeys: String, CodingKey { case season, races = "Races" }
    }
    struct Race: Decodable {
        let round: String
        let raceName: String
        let circuit: Circuit
        let date: String
        let time: String?
        let firstPractice: SessionTime?
        let secondPractice: SessionTime?
        let thirdPractice: SessionTime?
        let qualifying: SessionTime?
        let sprint: SessionTime?
        enum CodingKeys: String, CodingKey {
            case round, raceName, circuit = "Circuit", date, time
            case firstPractice = "FirstPractice"
            case secondPractice = "SecondPractice"
            case thirdPractice = "ThirdPractice"
            case qualifying = "Qualifying"
            case sprint = "Sprint"
        }
    }
    struct Circuit: Decodable {
        let circuitId: String
        let circuitName: String
        let location: Location
        enum CodingKeys: String, CodingKey { case circuitId, circuitName, location = "Location" }
    }
    struct Location: Decodable {
        let locality: String
        let country: String
    }
    struct SessionTime: Decodable {
        let date: String
        let time: String
    }
}
