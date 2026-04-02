// F1Repository.swift
// Data layer — the ONLY file that knows about SwiftData models and DTO types.
//
// Responsibilities:
//   • Cache-first reads: serve local SwiftData cache when fresh, else fetch remote.
//   • Map CachedXxx / DTO types → domain models before returning.
//   • Conform to F1RepositoryProtocol so the Presentation layer never imports SwiftData.

import Foundation
import SwiftData

@MainActor
final class F1Repository: F1RepositoryProtocol {
    private let modelContext: ModelContext
    private let jolpicaService: any JolpicaServicing
    private let openF1Service: any OpenF1Servicing

    private let standingsTTL: TimeInterval = 300     // 5 min
    private let scheduleTTL:  TimeInterval = 3_600   // 1 hr
    private let weatherTTL:   TimeInterval = 30      // 30 sec

    init(
        modelContext: ModelContext,
        jolpicaService: any JolpicaServicing = JolpicaService(),
        openF1Service: any OpenF1Servicing = OpenF1Service()
    ) {
        self.modelContext = modelContext
        self.jolpicaService = jolpicaService
        self.openF1Service = openF1Service
    }

    // MARK: - Driver Standings

    func driverStandings() async throws -> [F1DriverStanding] {
        let cached = local(CachedDriverStanding.self, sortBy: \.position)
        if fresh(cached.first?.updatedAt, ttl: standingsTTL) { return cached.map(\.domain) }
        return try await refreshDriverStandings()
    }

    @discardableResult
    func refreshDriverStandings() async throws -> [F1DriverStanding] {
        let remote = try await jolpicaService.fetchDriverStandings()
        try ctx.delete(model: CachedDriverStanding.self)

        let models: [CachedDriverStanding] = remote.compactMap { dto in
            guard let pos  = Int(dto.position),
                  let pts  = Double(dto.points),
                  let wins = Int(dto.wins),
                  let team = dto.constructors.first else { return nil }
            let m = CachedDriverStanding(
                driverId:   dto.driver.driverId,
                position:   pos,   points: pts, wins: wins,
                givenName:  dto.driver.givenName,
                familyName: dto.driver.familyName,
                code:       dto.driver.code ?? String(dto.driver.familyName.prefix(3)).uppercased(),
                teamName:   team.name,
                teamId:     team.constructorId
            )
            ctx.insert(m)
            return m
        }
        try ctx.save()
        return models.map(\.domain)
    }

    // MARK: - Constructor Standings

    func constructorStandings() async throws -> [F1ConstructorStanding] {
        let cached = local(CachedConstructorStanding.self, sortBy: \.position)
        if fresh(cached.first?.updatedAt, ttl: standingsTTL) { return cached.map(\.domain) }
        return try await refreshConstructorStandings()
    }

    @discardableResult
    func refreshConstructorStandings() async throws -> [F1ConstructorStanding] {
        let remote = try await jolpicaService.fetchConstructorStandings()
        try ctx.delete(model: CachedConstructorStanding.self)

        let models: [CachedConstructorStanding] = remote.compactMap { dto in
            guard let pos  = Int(dto.position),
                  let pts  = Double(dto.points),
                  let wins = Int(dto.wins) else { return nil }
            let m = CachedConstructorStanding(
                constructorId: dto.constructor.constructorId,
                position: pos, points: pts, wins: wins,
                name: dto.constructor.name
            )
            ctx.insert(m)
            return m
        }
        try ctx.save()
        return models.map(\.domain)
    }

    // MARK: - Race Schedule

    func raceSchedule() async throws -> [F1Race] {
        let cached = local(CachedRace.self, sortBy: \.raceDate)
        if fresh(cached.first?.updatedAt, ttl: scheduleTTL) { return cached.map(\.domain) }
        return try await refreshRaceSchedule()
    }

    @discardableResult
    func refreshRaceSchedule() async throws -> [F1Race] {
        let remote = try await jolpicaService.fetchRaceSchedule()
        try ctx.delete(model: CachedRace.self)

        let fmt = ISO8601DateFormatter()
        let models: [CachedRace] = remote.compactMap { dto in
            guard let round    = Int(dto.round),
                  let raceDate = parseDate(dto.date, time: dto.time, fmt: fmt) else { return nil }
            let m = CachedRace(
                round: round, season: 2025,
                raceName: dto.raceName,
                circuitName: dto.circuit.circuitName,
                country: dto.circuit.location.country,
                locality: dto.circuit.location.locality,
                raceDate: raceDate
            )
            m.qualifyingDate = parseDate(dto.qualifying?.date,     time: dto.qualifying?.time,     fmt: fmt)
            m.fp1Date        = parseDate(dto.firstPractice?.date,  time: dto.firstPractice?.time,  fmt: fmt)
            m.fp2Date        = parseDate(dto.secondPractice?.date, time: dto.secondPractice?.time, fmt: fmt)
            m.fp3Date        = parseDate(dto.thirdPractice?.date,  time: dto.thirdPractice?.time,  fmt: fmt)
            m.sprintDate     = parseDate(dto.sprint?.date,         time: dto.sprint?.time,         fmt: fmt)
            ctx.insert(m)
            return m
        }
        try ctx.save()
        return models.map(\.domain)
    }

    // MARK: - Weather

    func latestWeather() async throws -> F1Weather? {
        let cached = local(CachedWeather.self).first
        if fresh(cached?.updatedAt, ttl: weatherTTL) { return cached?.domain }
        return try await refreshWeather()
    }

    @discardableResult
    func refreshWeather() async throws -> F1Weather? {
        guard let dto = try await openF1Service.fetchLatestWeather() else { return nil }
        try ctx.delete(model: CachedWeather.self)
        let m = CachedWeather(
            sessionKey:       dto.sessionKey,
            airTemperature:   dto.airTemperature,
            trackTemperature: dto.trackTemperature,
            humidity:         dto.humidity,
            rainfall:         dto.rainfall,
            windSpeed:        dto.windSpeed
        )
        ctx.insert(m)
        try ctx.save()
        return m.domain
    }

    // MARK: - Live Timing (stateless — no SwiftData cache)

    func fetchLiveTiming() async throws -> [F1TimingEntry] {
        async let positions = openF1Service.fetchLatestPositions()
        async let intervals = openF1Service.fetchIntervals()
        async let drivers   = openF1Service.fetchDrivers()

        let (posData, intData, drvData) = try await (positions, intervals, drivers)

        let driverMap   = Dictionary(uniqueKeysWithValues: drvData.map { ($0.driverNumber, $0) })
        let intervalMap = Dictionary(uniqueKeysWithValues: intData.map { ($0.driverNumber, $0) })

        return posData.compactMap { pos in
            let drv = driverMap[pos.driverNumber]
            let gap = intervalMap[pos.driverNumber]
            return F1TimingEntry(
                id:           pos.driverNumber,
                position:     pos.position,
                driverNumber: pos.driverNumber,
                name:         drv?.fullName    ?? "Car \(pos.driverNumber)",
                acronym:      drv?.nameAcronym ?? "---",
                teamName:     drv?.teamName    ?? "Unknown",
                teamColorHex: drv?.teamColour  ?? "444444",
                gapToLeader:  formatGap(gap?.gapToLeader),
                interval:     formatGap(gap?.interval)
            )
        }.sorted { $0.position < $1.position }
    }

    // MARK: - Private helpers

    private func local<T: PersistentModel>(_ type: T.Type) -> [T] {
        return (try? ctx.fetch(FetchDescriptor<T>())) ?? []
    }

    private func local<T: PersistentModel, V: Comparable>(
        _ type: T.Type, sortBy keyPath: KeyPath<T, V>
    ) -> [T] {
        return (try? ctx.fetch(FetchDescriptor<T>(sortBy: [SortDescriptor(keyPath)]))) ?? []
    }

    private var ctx: ModelContext { modelContext }

    private func fresh(_ date: Date?, ttl: TimeInterval) -> Bool {
        guard let date else { return false }
        return Date.now.timeIntervalSince(date) < ttl
    }

    private func parseDate(_ date: String?, time: String?, fmt: ISO8601DateFormatter) -> Date? {
        guard let date else { return nil }
        return fmt.date(from: "\(date)T\(time ?? "00:00:00Z")")
    }

    private func formatGap(_ gap: Double?) -> String {
        guard let gap else { return "-" }
        return gap == 0 ? "LEADER" : String(format: "+%.3f", gap)
    }
}

// MARK: - SwiftData → Domain mappers
// Private to the Data layer. No other file references CachedXxx.

private extension CachedDriverStanding {
    var domain: F1DriverStanding {
        F1DriverStanding(
            id: driverId, position: position, points: points, wins: wins,
            givenName: givenName, familyName: familyName,
            code: code, teamName: teamName, teamId: teamId
        )
    }
}

private extension CachedConstructorStanding {
    var domain: F1ConstructorStanding {
        F1ConstructorStanding(
            id: constructorId, position: position,
            points: points, wins: wins, name: name
        )
    }
}

private extension CachedRace {
    var domain: F1Race {
        F1Race(
            id: round, season: season, raceName: raceName,
            circuitName: circuitName, country: country, locality: locality,
            raceDate: raceDate, qualifyingDate: qualifyingDate,
            fp1Date: fp1Date, fp2Date: fp2Date, fp3Date: fp3Date, sprintDate: sprintDate
        )
    }
}

private extension CachedWeather {
    var domain: F1Weather {
        F1Weather(
            airTemp: airTemperature, trackTemp: trackTemperature,
            humidity: humidity, rainfall: rainfall, windSpeed: windSpeed
        )
    }
}
