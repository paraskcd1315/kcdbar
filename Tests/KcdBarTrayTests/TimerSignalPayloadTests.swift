import Foundation
import KcdSignal
import Testing

@testable import KcdBarTray

struct TimerSignalPayloadTests {
    private let snapshot = """
        {"channel":"timer","publishedAt":"2026-08-15T20:28:21Z","timers":[\
        {"detail":"KCDBAR-33 consume the KcdSignal timer channel","isBillable":true,\
        "isRunning":true,"jiraKey":"KCDBAR-33","projectId":13,"seconds":2,"source":"kimai",\
        "startedAt":"2026-08-15T20:28:19Z"},\
        {"detail":"CC-280 the diff tree that will not collapse","isBillable":false,\
        "isRunning":true,"jiraKey":"CC-280","projectId":1,"seconds":5825,"source":"kimai",\
        "startedAt":"2026-08-15T18:51:16Z"}],"v":1}
        """

    private func decoded(_ json: String) throws -> SignalEnvelope<TimerSignalPayload> {
        try SignalCoding.decoder.decode(
            SignalEnvelope<TimerSignalPayload>.self,
            from: Data(json.utf8)
        )
    }

    @Test func thePayloadSitsBesideTheEnvelopeRatherThanUnderIt() throws {
        let envelope = try decoded(snapshot)

        #expect(envelope.channel == "timer")
        #expect(envelope.payload.timers.count == 2)
    }

    @Test func everyFieldTheWidgetNeedsSurvivesTheDecode() throws {
        let mine = try #require(
            decoded(snapshot).payload.runningTimers.first { $0.projectId == 13 }
        )

        #expect(mine.jiraKey == "KCDBAR-33")
        #expect(mine.detail == "KCDBAR-33 consume the KcdSignal timer channel")
        #expect(mine.isBillable)
        #expect(mine.source == "kimai")
        #expect(mine.startedAt == ISO8601DateFormatter().date(from: "2026-08-15T20:28:19Z"))
    }

    @Test func aTimerThatStoppedIsNotARunningOne() throws {
        let stopped = """
            {"channel":"timer","publishedAt":"2026-08-15T20:28:21Z","timers":[\
            {"detail":"done","isBillable":false,"isRunning":false,"jiraKey":null,\
            "projectId":13,"seconds":10,"source":"kimai",\
            "startedAt":"2026-08-15T20:28:19Z"}],"v":1}
            """

        #expect(try decoded(stopped).payload.runningTimers.isEmpty)
    }

    @Test func aVersionThisReaderDoesNotKnowIsRefused() {
        let future = """
            {"channel":"timer","publishedAt":"2026-08-15T20:28:21Z","timers":[],"v":2}
            """

        #expect(throws: (any Error).self) { try decoded(future) }
    }
}
