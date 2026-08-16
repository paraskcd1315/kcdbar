import Testing
@testable import KcdBarTaskbar

struct StartPinnedSectionsTests {
    private func pin(_ identifier: String, _ order: Int) -> PinnedApp {
        PinnedApp(bundleIdentifier: identifier, displayName: identifier, order: order)
    }

    private func band(_ id: String, _ identifiers: [String]) -> StartPinnedBand {
        StartPinnedBand(
            group: StartGroup(id: id, order: 0),
            applications: identifiers.map {
                InstalledApplication(bundleIdentifier: $0, displayName: $0, path: "")
            }
        )
    }

    @Test func everyNewPinLandsInTheDefaultBand() {
        let seeds = StartPinnedSections.seeds(
            pins: [pin("a", 0), pin("b", 1)],
            groups: [],
            memberships: []
        )

        #expect(seeds.groups.map(\.id) == [StartGroupMetrics.defaultGroupId])
        #expect(seeds.memberships.map(\.groupId) == [StartGroupMetrics.defaultGroupId, StartGroupMetrics.defaultGroupId])
        #expect(seeds.memberships.map(\.order) == [0, 1])
    }

    @Test func aPinThatAlreadyHasAHomeIsLeftWhereItIs() {
        let seeds = StartPinnedSections.seeds(
            pins: [pin("a", 0)],
            groups: [StartGroup(id: "custom.work", order: 0)],
            memberships: [StartGroupMembership(bundleIdentifier: "a", groupId: "custom.work", order: 0)]
        )

        #expect(seeds.groups.isEmpty)
        #expect(seeds.memberships.isEmpty)
    }

    @Test func anEmptyBandStillExistsSoSomethingCanBeDroppedIntoIt() {
        let bands = StartPinnedSections.bands(
            pins: [pin("a", 0)],
            groups: [StartGroup(id: "one", order: 0), StartGroup(id: "two", order: 1)],
            memberships: [StartGroupMembership(bundleIdentifier: "a", groupId: "one", order: 0)]
        )

        #expect(bands.map(\.group.id) == ["one", "two"])
        #expect(bands.last?.applications.isEmpty == true)
    }

    @Test func movingWithinABandReordersIt() {
        let moved = StartPinnedSections.moved(
            [band("one", ["a", "b", "c"])],
            moving: "c",
            to: "one",
            before: "a"
        )

        let order = moved.sorted { $0.order < $1.order }.map(\.bundleIdentifier)

        #expect(order == ["c", "a", "b"])
    }

    @Test func movingAcrossBandsLeavesTheOldOneAndJoinsTheNew() {
        let moved = StartPinnedSections.moved(
            [band("one", ["a", "b"]), band("two", ["c"])],
            moving: "a",
            to: "two",
            before: "c"
        )

        let two = moved.filter { $0.groupId == "two" }.sorted { $0.order < $1.order }
        let one = moved.filter { $0.groupId == "one" }

        #expect(two.map(\.bundleIdentifier) == ["a", "c"])
        #expect(one.map(\.bundleIdentifier) == ["b"])
    }

    @Test func droppingOnNoTileAppendsToTheBand() {
        let moved = StartPinnedSections.moved(
            [band("one", ["a", "b"]), band("two", [])],
            moving: "a",
            to: "two",
            before: nil
        )

        #expect(moved.filter { $0.groupId == "two" }.map(\.bundleIdentifier) == ["a"])
    }

    @Test func aPinTheStoreNoLongerHoldsDropsOutOfItsBand() {
        let bands = StartPinnedSections.bands(
            pins: [pin("a", 0)],
            groups: [StartGroup(id: "one", order: 0)],
            memberships: [
                StartGroupMembership(bundleIdentifier: "a", groupId: "one", order: 0),
                StartGroupMembership(bundleIdentifier: "gone", groupId: "one", order: 1)
            ]
        )

        #expect(bands.first?.applications.map(\.bundleIdentifier) == ["a"])
    }
}
