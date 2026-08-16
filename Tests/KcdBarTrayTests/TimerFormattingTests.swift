import Foundation
import Testing

@testable import KcdBarTray

struct TimerFormattingTests {
    private let started = Date(timeIntervalSince1970: 0)

    private func elapsed(_ seconds: TimeInterval) -> String {
        TimerFormatting.elapsed(since: started, at: started.addingTimeInterval(seconds))
    }

    @Test func underAnHourTheHoursAreLeftOff() {
        #expect(elapsed(0) == "0:00")
        #expect(elapsed(9) == "0:09")
        #expect(elapsed(605) == "10:05")
    }

    @Test func pastAnHourTheHoursAppearAndTheMinutesArePadded() {
        #expect(elapsed(3600) == "1:00:00")
        #expect(elapsed(3665) == "1:01:05")
        #expect(elapsed(36000) == "10:00:00")
    }

    @Test func aClockThatWentBackwardsReadsZeroRatherThanNegative() {
        #expect(elapsed(-30) == "0:00")
    }

    @Test func theTicketIsTheLabelWhenThereIsOne() {
        let timer = RunningTimer(
            projectId: 13,
            jiraKey: "KCDBAR-37",
            detail: "KCDBAR-37 consume the KcdSignal timer channel",
            startedAt: started,
            isBillable: true,
            source: "kimai"
        )

        #expect(TimerFormatting.label(for: timer) == "KCDBAR-37")
    }

    @Test func withoutATicketTheDescriptionStandsIn() {
        let timer = RunningTimer(
            projectId: 13,
            jiraKey: nil,
            detail: "reading a book",
            startedAt: started,
            isBillable: false,
            source: "kimai"
        )

        #expect(TimerFormatting.label(for: timer) == "reading a book")
    }
}
