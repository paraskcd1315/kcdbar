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
        zOrder: Int? = 0,
        source: WindowRecordSource = .both
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
            source: source
        )
    }

    private var overlapping: BarPreset {
        var preset = BarPresetCatalogue.default
        preset.autoHide = .whenOverlapped

        return preset
    }

    @Test func aCoreGraphicsOnlySurfaceOverTheBarDoesNotHideIt() {
        let phantom = window(
            id: 10,
            bounds: displays[0].frame,
            isFullScreen: false,
            source: .coreGraphicsOnly
        )

        #expect(
            BarVisibilityPolicy.isHidden(
                preset: overlapping,
                onDisplay: 1,
                windows: [phantom],
                displays: displays
            ) == false
        )
    }

    @Test func aConfirmedWindowOverTheBarStillHidesIt() {
        let real = window(id: 11, bounds: displays[0].frame, isFullScreen: false)

        #expect(
            BarVisibilityPolicy.isHidden(
                preset: overlapping,
                onDisplay: 1,
                windows: [real],
                displays: displays
            )
        )
    }

    @Test func aCoreGraphicsOnlySurfaceCannotPoseAsTheFrontmostWindow() {
        let phantom = window(
            id: 12,
            bounds: displays[0].frame,
            isFullScreen: true,
            zOrder: 0,
            source: .coreGraphicsOnly
        )

        #expect(
            BarVisibilityPolicy.isHidden(
                preset: BarPresetCatalogue.default,
                onDisplay: 1,
                windows: [phantom],
                displays: displays
            ) == false
        )
    }

    @Test func aFullScreenWindowHidesTheBarOnItsOwnDisplay() {
        let windows = [window(id: 10, bounds: displays[0].frame, isFullScreen: true)]

        #expect(BarVisibilityPolicy.isHidden(preset: BarPresetCatalogue.default, onDisplay: 1, windows: windows, displays: displays))
    }

    @Test func theOtherDisplaysBarStaysVisible() {
        let windows = [window(id: 10, bounds: displays[0].frame, isFullScreen: true)]

        #expect(BarVisibilityPolicy.isHidden(preset: BarPresetCatalogue.default, onDisplay: 2, windows: windows, displays: displays) == false)
    }

    @Test func aDisplayFillingWindowThatIsNotFullScreenLeavesTheBarAlone() {
        let windows = [window(id: 10, bounds: displays[0].frame, isFullScreen: false)]

        #expect(BarVisibilityPolicy.isHidden(preset: BarPresetCatalogue.default, onDisplay: 1, windows: windows, displays: displays) == false)
    }

    @Test func aMinimizedFullScreenWindowDoesNotHideTheBar() {
        let windows = [
            window(id: 10, bounds: displays[0].frame, isFullScreen: true, isMinimized: true, isOnScreen: false)
        ]

        #expect(BarVisibilityPolicy.isHidden(preset: BarPresetCatalogue.default, onDisplay: 1, windows: windows, displays: displays) == false)
    }

    @Test func aFullScreenWindowOnAnotherSpaceDoesNotHideTheBar() {
        let windows = [
            window(id: 10, bounds: displays[0].frame, isFullScreen: true, zOrder: Int.max),
            window(id: 11, bounds: CGRect(x: 40, y: 40, width: 800, height: 600), isFullScreen: false)
        ]

        #expect(BarVisibilityPolicy.isHidden(preset: BarPresetCatalogue.default, onDisplay: 1, windows: windows, displays: displays) == false)
    }

    @Test func aFullScreenWindowBehindAnOrdinaryOneDoesNotHideTheBar() {
        let windows = [
            window(id: 10, bounds: displays[0].frame, isFullScreen: true, zOrder: 4),
            window(id: 11, bounds: CGRect(x: 40, y: 40, width: 800, height: 600), isFullScreen: false, zOrder: 1)
        ]

        #expect(BarVisibilityPolicy.isHidden(preset: BarPresetCatalogue.default, onDisplay: 1, windows: windows, displays: displays) == false)
    }

    @Test func aFullScreenWindowInFrontOfAnOrdinaryOneHidesTheBar() {
        let windows = [
            window(id: 10, bounds: displays[0].frame, isFullScreen: true, zOrder: 1),
            window(id: 11, bounds: CGRect(x: 40, y: 40, width: 800, height: 600), isFullScreen: false, zOrder: 4)
        ]

        #expect(BarVisibilityPolicy.isHidden(preset: BarPresetCatalogue.default, onDisplay: 1, windows: windows, displays: displays))
    }

    @Test func anEmptyDisplayKeepsItsBar() {
        #expect(BarVisibilityPolicy.isHidden(preset: BarPresetCatalogue.default, onDisplay: 1, windows: [], displays: displays) == false)
    }

    @Test func aFullScreenWindowNamesItselfAsTheReason() {
        let windows = [window(id: 10, bounds: displays[0].frame, isFullScreen: true)]

        #expect(
            BarVisibilityPolicy.reason(
                preset: BarPresetCatalogue.default,
                onDisplay: 1,
                windows: windows,
                displays: displays
            ) == .fullScreenWindow
        )
    }

    @Test func anAlwaysHiddenBarNamesItsPresetAsTheReason() {
        var preset = BarPresetCatalogue.default
        preset.autoHide = .always

        #expect(
            BarVisibilityPolicy.reason(
                preset: preset,
                onDisplay: 1,
                windows: [],
                displays: displays
            ) == .alwaysHidden
        )
    }

    @Test func aWindowOverTheBarNamesTheOverlapAsTheReason() {
        let real = window(id: 11, bounds: displays[0].frame, isFullScreen: false)

        #expect(
            BarVisibilityPolicy.reason(
                preset: overlapping,
                onDisplay: 1,
                windows: [real],
                displays: displays
            ) == .overlappingWindow
        )
    }

    @Test func aBarThatNeverHidesHasNoReason() {
        var preset = BarPresetCatalogue.default
        preset.autoHide = .never

        let real = window(id: 11, bounds: displays[0].frame, isFullScreen: false)

        #expect(
            BarVisibilityPolicy.reason(
                preset: preset,
                onDisplay: 1,
                windows: [real],
                displays: displays
            ) == nil
        )
    }

    @Test func anEmptyDisplayHasNoReasonToHide() {
        #expect(
            BarVisibilityPolicy.reason(
                preset: overlapping,
                onDisplay: 1,
                windows: [],
                displays: displays
            ) == nil
        )
    }
}
