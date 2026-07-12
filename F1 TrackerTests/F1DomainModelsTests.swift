// F1DomainModelsTests.swift
// Unit tests for the pure domain-model logic in F1DomainModels.swift.

import Testing
import Foundation
@testable import F1_Tracker

struct F1DomainModelsTests {

    private func race(
        raceDate: Date,
        qualifyingDate: Date? = nil,
        fp1Date: Date? = nil,
        fp2Date: Date? = nil,
        fp3Date: Date? = nil,
        sprintDate: Date? = nil
    ) -> F1Race {
        F1Race(
            id: 1, season: 2026, raceName: "Test GP",
            circuitName: "Test Circuit", country: "Testland", locality: "Testville",
            raceDate: raceDate, qualifyingDate: qualifyingDate,
            fp1Date: fp1Date, fp2Date: fp2Date, fp3Date: fp3Date, sprintDate: sprintDate
        )
    }

    @Test func isUpcomingIsTrueForFutureRace() {
        let r = race(raceDate: .now.addingTimeInterval(86_400))
        #expect(r.isUpcoming)
    }

    @Test func isUpcomingIsFalseForPastRace() {
        let r = race(raceDate: .now.addingTimeInterval(-86_400))
        #expect(!r.isUpcoming)
    }

    @Test func nextSessionSkipsPastSessionsAndPicksEarliestFuture() {
        let now = Date.now
        let r = race(
            raceDate: now.addingTimeInterval(3 * 86_400),
            qualifyingDate: now.addingTimeInterval(2 * 86_400),
            fp1Date: now.addingTimeInterval(-3600),   // already happened
            fp2Date: now.addingTimeInterval(1800)     // next up
        )
        let next = r.nextSession
        #expect(next?.name == "Practice 2")
    }

    @Test func nextSessionReturnsNilWhenAllSessionsHavePassed() {
        let now = Date.now
        let r = race(raceDate: now.addingTimeInterval(-3600))
        #expect(r.nextSession == nil)
    }

    @Test func allSessionsAreSortedChronologically() {
        let now = Date.now
        let r = race(
            raceDate: now.addingTimeInterval(3 * 86_400),
            qualifyingDate: now.addingTimeInterval(2 * 86_400),
            fp1Date: now.addingTimeInterval(1 * 86_400)
        )
        let sessions = r.allSessions
        let dates = sessions.map(\.date)
        #expect(dates == dates.sorted())
        #expect(sessions.last?.isRace == true)
    }

    @Test func weatherIsWetOnlyWhenRainfallIsPositive() {
        let dry = F1Weather(airTemp: 25, trackTemp: 35, humidity: 40, rainfall: 0, windSpeed: 5)
        let wet = F1Weather(airTemp: 20, trackTemp: 22, humidity: 90, rainfall: 1.2, windSpeed: 10)
        #expect(!dry.isWet)
        #expect(wet.isWet)
    }
}
