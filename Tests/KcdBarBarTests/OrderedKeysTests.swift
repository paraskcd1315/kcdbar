import Testing
@testable import KcdBarBar

struct OrderedKeysTests {
    @Test func dedupeKeepsTheFirstSighting() {
        #expect(OrderedKeys.deduped(["a", "b", "a", "c", "b"]) == ["a", "b", "c"])
    }

    @Test func dedupeLeavesADistinctListAlone() {
        #expect(OrderedKeys.deduped(["a", "b", "c"]) == ["a", "b", "c"])
    }

    @Test func dedupeOfNothingIsNothing() {
        #expect(OrderedKeys.deduped([]).isEmpty)
    }
}
