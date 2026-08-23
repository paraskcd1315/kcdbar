import Foundation
import Testing

@testable import KcdBarTray

struct DayPanelReadingTests {
    private var utc: Calendar {
        var made = Calendar(identifier: .gregorian)

        made.timeZone = TimeZone.gmt

        return made
    }

    private let opens = Date(timeIntervalSince1970: 1_785_974_400)

    private func at(_ hour: Double) -> Date {
        opens.addingTimeInterval(hour * 3600)
    }

    private func entry() -> DayEntry {
        DayEntry(
            id: 1,
            detail: "KCDBAR-97 the day in the popover",
            projectId: 13,
            jiraKey: "KCDBAR-97",
            contextPath: "PersonalProjects/KCDBar",
            startedAt: at(9),
            endedAt: at(10),
            isBillable: false)
    }

    private func day(_ entries: [DayEntry]) -> TrackerDay {
        TrackerDay(day: opens, entries: entries, projects: [])
    }

    @Test func noChannelAtAllReadsAsAbsent() {
        #expect(DayPanelReading.of(nil, at: at(12), in: utc) == .absent)
    }

    @Test func aDayNobodyReplacedOvernightReadsAsStaleRatherThanEmpty() {
        #expect(DayPanelReading.of(day([entry()]), at: at(30), in: utc) == .stale)
    }

    @Test func todaysDayWithNothingOnItReadsAsEmpty() {
        #expect(DayPanelReading.of(day([]), at: at(12), in: utc) == .empty)
    }

    @Test func todaysDayWithTimeOnItIsTheOneThatDraws() {
        #expect(DayPanelReading.of(day([entry()]), at: at(12), in: utc) == .tracked(day([entry()])))
    }

    @Test func aStaleDayIsStaleEvenWhenItHasEntries() {
        let yesterday = TrackerDay(
            day: opens.addingTimeInterval(-86400), entries: [entry()], projects: [])

        #expect(DayPanelReading.of(yesterday, at: at(12), in: utc) == .stale)
    }

    @Test func anEmptyDayIsNotAnAbsentOne() {
        let empty = DayPanelReading.of(day([]), at: at(12), in: utc)

        #expect(empty != .absent)
        #expect(empty == .empty)
    }
}
