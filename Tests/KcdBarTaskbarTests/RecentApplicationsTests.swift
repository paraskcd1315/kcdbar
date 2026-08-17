import Foundation
import Testing
@testable import KcdBarTaskbar

struct RecentApplicationsTests {
    private let epoch = Date(timeIntervalSince1970: 1_760_000_000)

    private func installed(_ identifiers: [String]) -> [InstalledApplication] {
        identifiers.map {
            InstalledApplication(bundleIdentifier: $0, displayName: $0, path: "/Applications/\($0).app")
        }
    }

    private func usage(_ identifier: String, _ count: Int, _ offset: TimeInterval) -> ApplicationUsage {
        ApplicationUsage(
            bundleIdentifier: identifier,
            count: count,
            lastLaunchedAt: epoch.addingTimeInterval(offset)
        )
    }

    @Test func theMostLaunchedComesFirst() {
        let ranked = RecentApplications.ranked(
            [usage("a", 2, 0), usage("b", 9, 0), usage("c", 5, 0)],
            among: installed(["a", "b", "c"])
        )

        #expect(ranked.map(\.bundleIdentifier) == ["b", "c", "a"])
    }

    @Test func aTieGoesToWhicheverWasLaunchedLast() {
        let ranked = RecentApplications.ranked(
            [usage("older", 3, 0), usage("newer", 3, 60)],
            among: installed(["older", "newer"])
        )

        #expect(ranked.map(\.bundleIdentifier) == ["newer", "older"])
    }

    @Test func anApplicationThatIsGoneDropsOutOfTheList() {
        let ranked = RecentApplications.ranked(
            [usage("kept", 1, 0), usage("uninstalled", 99, 0)],
            among: installed(["kept"])
        )

        #expect(ranked.map(\.bundleIdentifier) == ["kept"])
    }

    @Test func theListStopsAtItsLimit() {
        let identifiers = (0..<20).map { "app\($0)" }
        let ranked = RecentApplications.ranked(
            identifiers.enumerated().map { usage($1, 20 - $0, 0) },
            among: installed(identifiers)
        )

        #expect(ranked.count == StartMenuMetrics.recentLimit)
        #expect(ranked.first?.bundleIdentifier == "app0")
    }

    @Test func nothingLaunchedYetIsAnEmptyList() {
        #expect(RecentApplications.ranked([], among: installed(["a"])).isEmpty)
    }
}
