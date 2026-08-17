import CoreGraphics
import Testing
@testable import KcdBarTaskbar

struct BarVisibilityTests {
    private let displays = [
        DisplayGeometry(id: 1, frame: CGRect(x: 0, y: 0, width: 1920, height: 1080), isPrimary: true),
        DisplayGeometry(id: 2, frame: CGRect(x: 1920, y: 0, width: 1920, height: 1080), isPrimary: false)
    ]

    private func window(
        id: CGWindowID,
        bounds: CGRect,
        isFullScreen: Bool,
        isMinimized: Bool = false,
        isOnScreen: Bool = true,
        zOrder: Int? = 0
    ) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: 1, cgWindowId: id, fallbackKey: "1:\(id)"),
            ownerPid: 1,
            ownerName: "App",
            title: "Window",
            bounds: bounds,
            isMinimized: isMinimized,
            isFullScreen: isFullScreen,
            isOnScreen: isOnScreen,
            zOrder: zOrder,
            source: .both
        )
    }

    @Test func aFullScreenWindowHidesTheBarOnItsOwnDisplay() {
        let windows = [window(id: 10, bounds: displays[0].frame, isFullScreen: true)]

        #expect(BarVisibilityPolicy.isHidden(onDisplay: 1, windows: windows, displays: displays))
    }

    @Test func theOtherDisplaysBarStaysVisible() {
        let windows = [window(id: 10, bounds: displays[0].frame, isFullScreen: true)]

        #expect(BarVisibilityPolicy.isHidden(onDisplay: 2, windows: windows, displays: displays) == false)
    }

    @Test func aDisplayFillingWindowThatIsNotFullScreenLeavesTheBarAlone() {
        let windows = [window(id: 10, bounds: displays[0].frame, isFullScreen: false)]

        #expect(BarVisibilityPolicy.isHidden(onDisplay: 1, windows: windows, displays: displays) == false)
    }

    @Test func aMinimizedFullScreenWindowDoesNotHideTheBar() {
        let windows = [
            window(id: 10, bounds: displays[0].frame, isFullScreen: true, isMinimized: true, isOnScreen: false)
        ]

        #expect(BarVisibilityPolicy.isHidden(onDisplay: 1, windows: windows, displays: displays) == false)
    }

    @Test func aFullScreenWindowOnAnotherSpaceDoesNotHideTheBar() {
        let windows = [
            window(id: 10, bounds: displays[0].frame, isFullScreen: true, zOrder: Int.max),
            window(id: 11, bounds: CGRect(x: 40, y: 40, width: 800, height: 600), isFullScreen: false)
        ]

        #expect(BarVisibilityPolicy.isHidden(onDisplay: 1, windows: windows, displays: displays) == false)
    }

    @Test func aFullScreenWindowBehindAnOrdinaryOneDoesNotHideTheBar() {
        let windows = [
            window(id: 10, bounds: displays[0].frame, isFullScreen: true, zOrder: 4),
            window(id: 11, bounds: CGRect(x: 40, y: 40, width: 800, height: 600), isFullScreen: false, zOrder: 1)
        ]

        #expect(BarVisibilityPolicy.isHidden(onDisplay: 1, windows: windows, displays: displays) == false)
    }

    @Test func aFullScreenWindowInFrontOfAnOrdinaryOneHidesTheBar() {
        let windows = [
            window(id: 10, bounds: displays[0].frame, isFullScreen: true, zOrder: 1),
            window(id: 11, bounds: CGRect(x: 40, y: 40, width: 800, height: 600), isFullScreen: false, zOrder: 4)
        ]

        #expect(BarVisibilityPolicy.isHidden(onDisplay: 1, windows: windows, displays: displays))
    }

    @Test func anEmptyDisplayKeepsItsBar() {
        #expect(BarVisibilityPolicy.isHidden(onDisplay: 1, windows: [], displays: displays) == false)
    }
}
