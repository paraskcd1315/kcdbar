import Testing
@testable import KcdBarTaskbar

struct StartPinnedBandsFallbackTests {
    private func pin(_ identifier: String, _ order: Int) -> PinnedApp {
        PinnedApp(bundleIdentifier: identifier, displayName: identifier, order: order)
    }

    @Test func aPinShowsTheMomentItIsPinned() {
        let bands = StartPinnedSections.bands(pins: [pin("whatsapp", 0)], groups: [], memberships: [])

        #expect(bands.map(\.group.id) == [StartGroupMetrics.defaultGroupId])
        #expect(bands.first?.applications.map(\.bundleIdentifier) == ["whatsapp"])
    }

    @Test func anUnseededPinJoinsTheDefaultBandBehindTheOnesAlreadyThere() {
        let bands = StartPinnedSections.bands(
            pins: [pin("held", 0), pin("fresh", 1)],
            groups: [
                StartGroup(id: StartGroupMetrics.defaultGroupId, order: 0),
                StartGroup(id: "custom.work", order: 1)
            ],
            memberships: [
                StartGroupMembership(
                    bundleIdentifier: "held",
                    groupId: StartGroupMetrics.defaultGroupId,
                    order: 0
                )
            ]
        )

        #expect(bands.first?.applications.map(\.bundleIdentifier) == ["held", "fresh"])
    }

    @Test func aPinAlreadyLivingInACustomBandIsNotPulledBack() {
        let bands = StartPinnedSections.bands(
            pins: [pin("a", 0)],
            groups: [StartGroup(id: "custom.work", order: 0)],
            memberships: [
                StartGroupMembership(bundleIdentifier: "a", groupId: "custom.work", order: 0)
            ]
        )

        #expect(bands.map(\.group.id) == ["custom.work"])
        #expect(bands.first?.applications.count == 1)
    }
}
