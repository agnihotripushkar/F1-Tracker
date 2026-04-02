import Foundation
import SwiftData

@MainActor
struct AppDependencies {
    let repository: any F1RepositoryProtocol

    static func live(modelContext: ModelContext) -> Self {
        Self(repository: F1Repository(modelContext: modelContext))
    }

    static let preview = Self(repository: PreviewF1Repository())
}

@MainActor
final class PreviewF1Repository: F1RepositoryProtocol {
    func driverStandings() async throws -> [F1DriverStanding] { sampleDriverStandings }
    func constructorStandings() async throws -> [F1ConstructorStanding] { sampleConstructorStandings }
    func raceSchedule() async throws -> [F1Race] { sampleSchedule }
    func latestWeather() async throws -> F1Weather? { sampleWeather }

    func refreshDriverStandings() async throws -> [F1DriverStanding] { sampleDriverStandings }
    func refreshConstructorStandings() async throws -> [F1ConstructorStanding] { sampleConstructorStandings }
    func refreshRaceSchedule() async throws -> [F1Race] { sampleSchedule }
    func refreshWeather() async throws -> F1Weather? { sampleWeather }
    func fetchLiveTiming() async throws -> [F1TimingEntry] { sampleTiming }

    private let sampleDriverStandings: [F1DriverStanding] = [
        F1DriverStanding(
            id: "lando_norris",
            position: 1,
            points: 62,
            wins: 2,
            givenName: "Lando",
            familyName: "Norris",
            code: "NOR",
            teamName: "McLaren",
            teamId: "mclaren"
        ),
        F1DriverStanding(
            id: "max_verstappen",
            position: 2,
            points: 55,
            wins: 1,
            givenName: "Max",
            familyName: "Verstappen",
            code: "VER",
            teamName: "Red Bull Racing",
            teamId: "red_bull"
        )
    ]

    private let sampleConstructorStandings: [F1ConstructorStanding] = [
        F1ConstructorStanding(id: "mclaren", position: 1, points: 109, wins: 2, name: "McLaren"),
        F1ConstructorStanding(id: "red_bull", position: 2, points: 88, wins: 1, name: "Red Bull Racing")
    ]

    private let sampleSchedule: [F1Race] = [
        F1Race(
            id: 3,
            season: 2026,
            raceName: "Australian Grand Prix",
            circuitName: "Albert Park Grand Prix Circuit",
            country: "Australia",
            locality: "Melbourne",
            raceDate: .now.addingTimeInterval(86_400 * 3),
            qualifyingDate: .now.addingTimeInterval(86_400 * 2),
            fp1Date: .now.addingTimeInterval(86_400),
            fp2Date: .now.addingTimeInterval(86_400 + 14_400),
            fp3Date: nil,
            sprintDate: nil
        )
    ]

    private let sampleWeather = F1Weather(
        airTemp: 24,
        trackTemp: 37,
        humidity: 58,
        rainfall: 0,
        windSpeed: 9
    )

    private let sampleTiming: [F1TimingEntry] = [
        F1TimingEntry(
            id: 4,
            position: 1,
            driverNumber: 4,
            name: "Lando Norris",
            acronym: "NOR",
            teamName: "McLaren",
            teamColorHex: "FF8000",
            gapToLeader: "LEADER",
            interval: "-"
        ),
        F1TimingEntry(
            id: 1,
            position: 2,
            driverNumber: 1,
            name: "Max Verstappen",
            acronym: "VER",
            teamName: "Red Bull Racing",
            teamColorHex: "3671C6",
            gapToLeader: "+1.248",
            interval: "+1.248"
        )
    ]
}
