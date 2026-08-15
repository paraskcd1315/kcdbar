import CoreGraphics
import Testing

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
        isOnScreen: Bool = true
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
            zOrder: 0,
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

    @Test func anOffScreenFullScreenWindowOnAnotherSpaceDoesNotHideTheBar() {
        let windows = [window(id: 10, bounds: displays[0].frame, isFullScreen: true, isOnScreen: false)]

        #expect(BarVisibilityPolicy.isHidden(onDisplay: 1, windows: windows, displays: displays) == false)
    }
}
