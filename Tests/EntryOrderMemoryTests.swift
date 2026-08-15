import Testing

@MainActor
struct EntryOrderMemoryTests {
    @Test func seedingPutsStoredKeysFirstEvenWhenWindowsArrivedFirst() {
        let order = EntryOrderMemory()
        order.note(keys: ["app:com.iterm", "app:com.chrome"])

        order.seed(keys: ["app:com.chrome", "app:com.iterm"])

        #expect(order.keys == ["app:com.chrome", "app:com.iterm"])
    }

    @Test func seedingKeepsAPinnedApplicationThatHasNoWindowYet() {
        let order = EntryOrderMemory()
        order.note(keys: ["app:com.iterm"])

        order.seed(keys: ["app:com.chrome"])

        #expect(order.keys == ["app:com.chrome", "app:com.iterm"])
    }

    @Test func seedingLeavesUnpinnedEntriesAfterTheStoredOnes() {
        let order = EntryOrderMemory()
        order.note(keys: ["cg:10", "app:com.chrome", "cg:11"])

        order.seed(keys: ["app:com.chrome"])

        #expect(order.keys == ["app:com.chrome", "cg:10", "cg:11"])
    }

    @Test func notingDropsDeadKeysAndAppendsNewOnes() {
        let order = EntryOrderMemory()
        order.note(keys: ["cg:10", "cg:11"])

        order.note(keys: ["cg:11", "cg:12"])

        #expect(order.keys == ["cg:11", "cg:12"])
    }

    @Test func notingNeverReordersWhatIsAlreadyHeld() {
        let order = EntryOrderMemory()
        order.note(keys: ["app:com.chrome", "app:com.iterm"])

        order.note(keys: ["app:com.iterm", "app:com.chrome"])

        #expect(order.keys == ["app:com.chrome", "app:com.iterm"])
    }

    @Test func aMoveSurvivesTheNextRefresh() {
        let order = EntryOrderMemory()
        order.note(keys: ["app:com.iterm", "app:com.chrome"])

        order.move(key: "app:com.chrome", onto: "app:com.iterm")
        order.note(keys: ["app:com.iterm", "app:com.chrome"])

        #expect(order.keys == ["app:com.chrome", "app:com.iterm"])
    }
}
