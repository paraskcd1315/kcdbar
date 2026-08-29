import CoreGraphics
import Testing

@testable import KcdBarTaskbar

struct WindowSpacePolicyTests {
    private func window(zOrder: Int?) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: 1, cgWindowId: 1, fallbackKey: "1"),
            ownerPid: 1,
            ownerName: "App",
            title: "W",
            bounds: WindowFixtures.defaultBounds,
            isMinimized: false,
            isFullScreen: false,
            isOnScreen: true,
            zOrder: zOrder,
            source: .both
        )
    }

    @Test func aRankedWindowIsOnTheActiveSpace() {
        #expect(WindowSpacePolicy.isOnActiveSpace(window(zOrder: 3)))
    }

    @Test func theSentinelRankMeansAnotherSpace() {
        #expect(WindowSpacePolicy.isOnActiveSpace(window(zOrder: Int.max)) == false)
    }

    @Test func anUnrankedWindowIsNotOnTheActiveSpace() {
        #expect(WindowSpacePolicy.isOnActiveSpace(window(zOrder: nil)) == false)
    }
}
