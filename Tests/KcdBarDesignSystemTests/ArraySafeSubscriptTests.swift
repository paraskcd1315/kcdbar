import Testing

@testable import KcdBarDesignSystem

struct ArraySafeSubscriptTests {
    private let entries = ["clock", "battery", "wifi"]

    @Test func anIndexInsideTheArrayAnswersItsElement() {
        #expect(entries[safe: 0] == "clock")
        #expect(entries[safe: 2] == "wifi")
    }

    @Test func anIndexPastTheEndAnswersNilRatherThanTrapping() {
        #expect(entries[safe: 3] == nil)
        #expect(entries[safe: 99] == nil)
    }

    @Test func aNegativeIndexAnswersNilRatherThanTrapping() {
        #expect(entries[safe: -1] == nil)
    }

    @Test func anEmptyArrayAnswersNilForEveryIndex() {
        let empty: [String] = []

        #expect(empty[safe: 0] == nil)
        #expect(empty[safe: -1] == nil)
    }
}
