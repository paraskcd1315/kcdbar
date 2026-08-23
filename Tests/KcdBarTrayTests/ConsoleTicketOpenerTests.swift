import Foundation
import Testing

@testable import KcdBarTray

struct ConsoleTicketOpenerTests {
    @Test func aConsoleThatStartedAfterUsIsStillFound() async {
        let started = ConsoleServer(port: 62029, token: "t")
        let answers = Answers(values: [nil, started])
        let opener = ConsoleTicketOpener(read: { answers.next() })

        #expect(opener.isAvailable == false)
        #expect(opener.isAvailable)
    }

    @Test func noConsoleAtAllIsRefusedRatherThanAttempted() async {
        let opener = ConsoleTicketOpener(read: { nil })

        let opened = await opener.open(contextPath: "PersonalProjects/KCDBar", key: "KCDBAR-97")

        #expect(opened == false)
    }

    @Test func aConsoleThatStopsIsNoLongerReportedAvailable() {
        let answers = Answers(values: [ConsoleServer(port: 62029, token: "t"), nil])
        let opener = ConsoleTicketOpener(read: { answers.next() })

        #expect(opener.isAvailable)
        #expect(opener.isAvailable == false)
    }

    @Test func thePortIsReadEveryTimeRatherThanOnceAtLaunch() async {
        let answers = Answers(values: [nil, nil])
        let opener = ConsoleTicketOpener(read: { answers.next() })

        _ = opener.isAvailable
        _ = await opener.open(contextPath: "PersonalProjects/KCDBar", key: "KCDBAR-97")

        #expect(answers.taken == 2)
    }
}

private final class Answers: @unchecked Sendable {
    private let lock = NSLock()
    private var values: [ConsoleServer?]
    private var index = 0

    init(values: [ConsoleServer?]) {
        self.values = values
    }

    var taken: Int { lock.withLock { index } }

    func next() -> ConsoleServer? {
        lock.withLock {
            guard index < values.count else { return nil }

            defer { index += 1 }

            return values[index]
        }
    }
}
