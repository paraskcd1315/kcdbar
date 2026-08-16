import Testing
@testable import KcdBarTaskbar

private final class FakeLoginItem: LoginItemPort, @unchecked Sendable {
    var enabled: Bool
    private(set) var writes: [Bool] = []

    init(enabled: Bool) {
        self.enabled = enabled
    }

    var isEnabled: Bool { enabled }

    func setEnabled(_ enabled: Bool) {
        writes.append(enabled)
        self.enabled = enabled
    }
}

@MainActor
struct LoginItemStateTests {
    @Test func readsTheServicesAnswerAtBirth() {
        let port = FakeLoginItem(enabled: true)

        #expect(LoginItemState(port: port).isEnabled)
    }

    @Test func togglingWritesTheOppositeAndReadsBack() {
        let port = FakeLoginItem(enabled: false)
        let state = LoginItemState(port: port)

        state.toggle()

        #expect(port.writes == [true])
        #expect(state.isEnabled)
    }

    @Test func aRefusedWriteLeavesTheStateOnWhatTheServiceReports() {
        let port = FakeLoginItem(enabled: false)
        let state = LoginItemState(port: port)
        port.enabled = false

        state.toggle()
        port.enabled = false
        state.refresh()

        #expect(state.isEnabled == false)
    }
}
