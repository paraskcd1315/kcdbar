import Foundation
import KcdSignal
import Testing

@testable import KcdBarTray

struct SessionsSignalTests {
    private let snapshot = """
        {"channel":"sessions","publishedAt":"2026-08-23T20:15:00Z","sessions":[\
        {"contextLimit":1000000,"contextTokens":790000,"doing":"Bash","isTerminal":true,\
        "outputTokens":27000,"pane":"ClaudeContext:@0.%0","project":"KCDBar",\
        "quietSince":"2026-08-23T20:12:00Z","sessionId":"a","standing":"waiting",\
        "title":"kcdbar-43","waitingFor":"approve Bash"},\
        {"isTerminal":false,"sessionId":"b","standing":"busy","title":"a console chat"}],\
        "v":1}
        """

    private func decoded(_ json: String) throws -> SignalEnvelope<SessionsSignal> {
        try SignalCoding.decoder.decode(SignalEnvelope<SessionsSignal>.self, from: Data(json.utf8))
    }

    private func sessions(_ json: String) throws -> [ClaudeSession] {
        try decoded(json).payload.toEntity()
    }

    @Test func thePayloadSitsBesideTheEnvelopeRatherThanUnderIt() throws {
        let envelope = try decoded(snapshot)

        #expect(envelope.channel == "sessions")
        #expect(envelope.payload.sessions.count == 2)
    }

    @Test func everyFieldARowNeedsSurvivesTheDecode() throws {
        let waiting = try #require(sessions(snapshot).first { $0.sessionId == "a" })

        #expect(waiting.title == "kcdbar-43")
        #expect(waiting.standing == .waiting)
        #expect(waiting.waitingFor == "approve Bash")
        #expect(waiting.project == "KCDBar")
        #expect(waiting.doing == "Bash")
        #expect(waiting.outputTokens == 27_000)
        #expect(waiting.isTerminal)
        #expect(waiting.pane == "ClaudeContext:@0.%0")
        #expect(waiting.hasPane)
    }

    @Test func howFullTheWindowIsArrivesAsAShareTheRowCanDraw() throws {
        let context = try #require(sessions(snapshot).first { $0.sessionId == "a" }?.context)

        #expect(context.tokens == 790_000)
        #expect(context.share == 0.79)
        #expect(context.isTight)
        #expect(context.isCritical == false)
    }

    @Test func aSessionNobodyMeasuredCarriesNoContextRatherThanAnEmptyOne() throws {
        let chat = try #require(sessions(snapshot).first { $0.sessionId == "b" })

        #expect(chat.context == nil)
        #expect(chat.outputTokens == nil)
        #expect(chat.hasPane == false)
    }

    @Test func aStandingThisReaderDoesNotKnowIsNoneRatherThanAGuess() throws {
        let odd = """
            {"channel":"sessions","publishedAt":"2026-08-23T20:15:00Z","sessions":[\
            {"isTerminal":false,"sessionId":"c","standing":"pondering","title":"x"}],"v":1}
            """

        let session = try #require(sessions(odd).first)

        #expect(session.standing == nil)
        #expect(session.isWorking == false)
        #expect(session.isBlocked == false)
    }

    @Test func nothingRunningDecodesAsAnEmptyListRatherThanFailing() throws {
        let empty = """
            {"channel":"sessions","publishedAt":"2026-08-23T20:15:00Z","sessions":[],"v":1}
            """

        #expect(try sessions(empty).isEmpty)
    }

    @Test func aVersionThisReaderDoesNotKnowIsRefused() {
        let future = """
            {"channel":"sessions","publishedAt":"2026-08-23T20:15:00Z","sessions":[],"v":2}
            """

        #expect(throws: (any Error).self) { try decoded(future) }
    }

    @Test func howLongItHasBeenQuietIsMeasuredFromTheStampItCarries() throws {
        let waiting = try #require(sessions(snapshot).first { $0.sessionId == "a" })
        let now = try #require(ISO8601DateFormatter().date(from: "2026-08-23T20:15:00Z"))

        #expect(waiting.quietFor(at: now) == 180)
    }
}
