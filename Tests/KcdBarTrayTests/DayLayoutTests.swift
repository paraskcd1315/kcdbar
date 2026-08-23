import Foundation
import Testing

@testable import KcdBarTray

struct DayLayoutTests {
    private var utc: Calendar {
        var made = Calendar(identifier: .gregorian)

        made.timeZone = TimeZone.gmt

        return made
    }

    private let opens = Date(timeIntervalSince1970: 1_785_974_400)

    private func at(_ hour: Double) -> Date {
        opens.addingTimeInterval(hour * 3600)
    }

    private func entry(_ id: Int, from: Double, to: Double?) -> DayEntry {
        DayEntry(
            id: id,
            detail: "entry \(id)",
            projectId: 13,
            jiraKey: nil,
            contextPath: nil,
            startedAt: at(from),
            endedAt: to.map(at),
            isBillable: false)
    }

    private func blocks(_ entries: [DayEntry], at now: Date? = nil) -> [DayBlock] {
        DayLayout.blocks(of: entries, on: opens, in: utc, at: now ?? at(23))
    }

    private func isClose(_ made: Double, _ wanted: Double) -> Bool {
        abs(made - wanted) < 1e-12
    }

    @Test func aDayWithNothingOnItPlacesNothing() {
        #expect(blocks([]).isEmpty)
    }

    @Test func anEntryIsPlacedByWhereItBeganInTheDay() {
        let placed = blocks([entry(1, from: 6, to: 12)])

        #expect(placed.count == 1)
        #expect(isClose(placed[0].top, 0.25))
        #expect(isClose(placed[0].height, 0.25))
    }

    @Test func anEntryThatOverlapsNothingTakesTheWholeWidth() {
        let placed = blocks([entry(1, from: 6, to: 7)])

        #expect(placed[0].column == 0)
        #expect(placed[0].columns == 1)
    }

    @Test func twoEntriesRunningAtOnceDivideTheWidthBetweenThem() {
        let placed = blocks([entry(1, from: 6, to: 8), entry(2, from: 7, to: 9)])

        #expect(placed.allSatisfy { $0.columns == 2 })
        #expect(Set(placed.map(\.column)) == [0, 1])
    }

    @Test func threeAtOnceDivideThreeWays() {
        let placed = blocks([
            entry(1, from: 6, to: 9), entry(2, from: 7, to: 10), entry(3, from: 8, to: 11),
        ])

        #expect(placed.allSatisfy { $0.columns == 3 })
        #expect(Set(placed.map(\.column)) == [0, 1, 2])
    }

    @Test func aGapStartsAFreshDivisionRatherThanNarrowingTheWholeDay() {
        let placed = blocks([
            entry(1, from: 6, to: 8), entry(2, from: 7, to: 9), entry(3, from: 14, to: 15),
        ])

        let alone = try? #require(placed.first { $0.id == 3 })

        #expect(alone?.columns == 1)
        #expect(placed.first { $0.id == 1 }?.columns == 2)
    }

    @Test func aColumnIsReusedOnceTheEntryHoldingItHasEnded() {
        let placed = blocks([
            entry(1, from: 6, to: 8), entry(2, from: 7, to: 11), entry(3, from: 9, to: 10),
        ])

        #expect(placed.first { $0.id == 1 }?.column == 0)
        #expect(placed.first { $0.id == 2 }?.column == 1)
        #expect(placed.first { $0.id == 3 }?.column == 0)
    }

    @Test func anEntryBelongingToAnotherDayIsNotPlaced() {
        let elsewhere = DayEntry(
            id: 9,
            detail: "yesterday",
            projectId: nil,
            jiraKey: nil,
            contextPath: nil,
            startedAt: at(-6),
            endedAt: at(-5),
            isBillable: false)

        #expect(blocks([elsewhere]).isEmpty)
    }

    @Test func anEntryCrossingIntoTheDayIsClippedToItsStart() {
        let overnight = DayEntry(
            id: 9,
            detail: "late",
            projectId: nil,
            jiraKey: nil,
            contextPath: nil,
            startedAt: at(-1),
            endedAt: at(1),
            isBillable: false)

        let placed = blocks([overnight])

        #expect(isClose(placed[0].top, 0))
        #expect(isClose(placed[0].height, 1.0 / 24))
    }

    @Test func anEntryCrossingOutOfTheDayIsClippedToItsEnd() {
        let overnight = DayEntry(
            id: 9,
            detail: "later",
            projectId: nil,
            jiraKey: nil,
            contextPath: nil,
            startedAt: at(23),
            endedAt: at(25),
            isBillable: false)

        let placed = blocks([overnight])

        #expect(isClose(placed[0].top, 23.0 / 24))
        #expect(isClose(placed[0].height, 1.0 / 24))
    }

    @Test func aRunningEntryEndsAtTheMomentTheCallerStates() {
        let placed = blocks([entry(1, from: 6, to: nil)], at: at(9))

        #expect(isClose(placed[0].top, 0.25))
        #expect(isClose(placed[0].height, 3.0 / 24))
    }

    @Test func aRunningEntryGrowsAsTheStatedMomentMovesOn() {
        let earlier = blocks([entry(1, from: 6, to: nil)], at: at(9))
        let later = blocks([entry(1, from: 6, to: nil)], at: at(11))

        #expect((later[0].height) > (earlier[0].height))
        #expect(isClose(later[0].top, earlier[0].top))
    }

    @Test func aRunningEntryStillDividesTheWidthWithWhatItOverlaps() {
        let placed = blocks([entry(1, from: 6, to: 10), entry(2, from: 8, to: nil)], at: at(9))

        #expect(placed.allSatisfy { $0.columns == 2 })
    }

    @Test func entriesBeginningTogetherAreOrderedByTheIdTheTrackerGave() {
        let placed = blocks([entry(9, from: 6, to: 7), entry(4, from: 6, to: 7)])

        #expect(placed.map(\.id) == [4, 9])
    }

    @Test func twoEntriesTouchingAtAMinuteBoundaryDoNotCountAsOverlapping() {
        let placed = blocks([entry(1, from: 6, to: 7), entry(2, from: 7, to: 8)])

        #expect(placed.allSatisfy { $0.columns == 1 })
    }
}
