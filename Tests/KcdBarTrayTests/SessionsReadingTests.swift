import Foundation
import Testing

@testable import KcdBarTray

struct SessionsReadingTests {
    private func session(_ id: String, _ standing: SessionStanding?) -> ClaudeSession {
        ClaudeSession(
            sessionId: id,
            title: id,
            standing: standing,
            waitingFor: nil,
            quietSince: nil,
            isTerminal: false,
            pane: nil,
            project: nil,
            doing: nil,
            outputTokens: nil,
            context: nil)
    }

    @Test func noChannelAtAllReadsAsUnknown() {
        #expect(SessionsReading.of(nil) == .unknown)
    }

    @Test func nothingRunningIsQuiet() {
        #expect(SessionsReading.of([]) == .quiet)
    }

    @Test func everySessionStoppedIsQuietRatherThanUnknown() {
        #expect(SessionsReading.of([session("a", .idle), session("b", .idle)]) == .quiet)
    }

    @Test func oneWorkingSessionIsWorking() {
        #expect(SessionsReading.of([session("a", .idle), session("b", .busy)]) == .working)
    }

    @Test func aShellCountsAsWorking() {
        #expect(SessionsReading.of([session("a", .shell)]) == .working)
    }

    @Test func oneWaitingSessionBeatsThreeWorkingOnes() {
        let four = [
            session("a", .busy), session("b", .busy), session("c", .busy), session("d", .waiting),
        ]

        #expect(SessionsReading.of(four) == .waiting)
    }

    @Test func waitingIsTheOnlyReadingThatWantsHim() {
        #expect(SessionsReading.waiting.wantsAttention)
        #expect(SessionsReading.working.wantsAttention == false)
        #expect(SessionsReading.quiet.wantsAttention == false)
        #expect(SessionsReading.unknown.wantsAttention == false)
    }

    @Test func waitingStillDrawsTheRimBecauseSomethingIsStillLive() {
        #expect(SessionsReading.waiting.isWorking)
        #expect(SessionsReading.working.isWorking)
        #expect(SessionsReading.quiet.isWorking == false)
        #expect(SessionsReading.unknown.isWorking == false)
    }

    @Test func aStandingNobodyStatedCountsAsNeitherWorkingNorWaiting() {
        #expect(SessionsReading.of([session("a", nil)]) == .quiet)
    }
}
