import Foundation
import Testing

struct MenuBarItemPolicyTests {
    private func item(bundle: String?, pid: pid_t = 1, index: Int = 0) -> MenuBarItem {
        MenuBarItem(
            ownerPid: pid,
            bundleIdentifier: bundle,
            applicationName: bundle ?? "",
            label: nil,
            frame: nil,
            index: index
        )
    }

    @Test func aThirdPartyItemIsHosted() {
        #expect(MenuBarItemPolicy.isHostable(bundleIdentifier: "io.tailscale.ipn.macsys"))
    }

    @Test func applesOwnItemsAreReplacedByOurReadoutsNotProxied() {
        #expect(MenuBarItemPolicy.isHostable(bundleIdentifier: "com.apple.controlcenter") == false)
        #expect(MenuBarItemPolicy.isHostable(bundleIdentifier: "com.apple.Spotlight") == false)
    }

    @Test func anItemWithoutABundleIdentifierIsNotHosted() {
        #expect(MenuBarItemPolicy.isHostable(bundleIdentifier: nil) == false)
        #expect(MenuBarItemPolicy.isHostable(bundleIdentifier: "") == false)
    }

    @Test func filteringKeepsOnlyHostableItems() {
        let items = [
            item(bundle: "com.apple.controlcenter"),
            item(bundle: "io.tailscale.ipn.macsys", pid: 2),
            item(bundle: String?.none, pid: 3)
        ]

        let hosted = MenuBarItemPolicy.hostable(items)

        #expect(hosted.map(\.bundleIdentifier) == ["io.tailscale.ipn.macsys"])
    }

    @Test func severalItemsOfOneApplicationKeepDistinctIdentities() {
        let first = item(bundle: "com.example.app", index: 0)
        let second = item(bundle: "com.example.app", index: 1)

        #expect(first.id != second.id)
    }
}
