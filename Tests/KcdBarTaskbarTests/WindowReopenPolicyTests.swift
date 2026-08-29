import Testing
@testable import KcdBarTaskbar

struct WindowReopenPolicyTests {
    @Test func aRaiseThatFailedReopens() {
        #expect(WindowReopenPolicy.reopens(after: .raise, performed: false))
    }

    @Test func aRestoreThatFailedReopens() {
        #expect(WindowReopenPolicy.reopens(after: .restore, performed: false))
    }

    @Test func aMinimizeThatFailedDoesNotReopen() {
        #expect(WindowReopenPolicy.reopens(after: .minimize, performed: false) == false)
    }

    @Test func aRaiseThatSucceededDoesNotReopen() {
        #expect(WindowReopenPolicy.reopens(after: .raise, performed: true) == false)
    }
}
