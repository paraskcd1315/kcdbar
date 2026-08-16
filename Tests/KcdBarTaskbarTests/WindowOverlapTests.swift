import CoreGraphics
import Testing
@testable import KcdBarTaskbar

struct WindowOverlapTests {
    private let display = DisplayGeometry(
        id: 1,
        frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
        isPrimary: true
    )
    private let bottomBar = CGRect(x: 0, y: 0, width: 1920, height: 48)

    private func window(_ bounds: CGRect, minimized: Bool = false) -> ManagedWindow {
        let cg = WindowFixtures.cgRecord(windowId: 1, pid: 1, title: "W", bounds: bounds)
        let ax = WindowFixtures.axRecord(pid: 1, cgWindowId: 1, title: "W", bounds: bounds, isMinimized: minimized)
        return WindowReconciler.reconcile(coreGraphics: minimized ? [] : [cg], accessibility: .answered([ax]), previous: [])[0]
    }

    @Test func zoomedWindowIsPushedAboveABottomBar() {
        let zoomed = window(CGRect(x: 0, y: 0, width: 1920, height: 1080))

        let corrected = WindowOverlapPolicy.correctedFrame(for: zoomed, barFrame: bottomBar, display: display)

        #expect(corrected == CGRect(x: 0, y: 48, width: 1920, height: 1032))
    }

    @Test func aWindowThatDoesNotFillTheDisplayIsLeftAlone() {
        let small = window(CGRect(x: 100, y: 0, width: 600, height: 400))

        let corrected = WindowOverlapPolicy.correctedFrame(for: small, barFrame: bottomBar, display: display)

        #expect(corrected == nil)
    }

    @Test func aZoomedWindowClearOfTheBarIsLeftAlone() {
        let clear = window(CGRect(x: 0, y: 48, width: 1920, height: 1032))

        let corrected = WindowOverlapPolicy.correctedFrame(for: clear, barFrame: bottomBar, display: display)

        #expect(corrected == nil)
    }

    @Test func aMinimizedWindowIsNeverMoved() {
        let away = window(CGRect(x: 0, y: 0, width: 1920, height: 1080), minimized: true)

        let corrected = WindowOverlapPolicy.correctedFrame(for: away, barFrame: bottomBar, display: display)

        #expect(corrected == nil)
    }

    @Test func usableAreaExcludesATopBar() {
        let topBar = CGRect(x: 0, y: 1032, width: 1920, height: 48)

        let usable = WindowOverlapPolicy.usableArea(of: display, excluding: topBar)

        #expect(usable == CGRect(x: 0, y: 0, width: 1920, height: 1032))
    }

    @Test func usableAreaExcludesALeadingBar() {
        let leadingBar = CGRect(x: 0, y: 0, width: 64, height: 1080)

        let usable = WindowOverlapPolicy.usableArea(of: display, excluding: leadingBar)

        #expect(usable == CGRect(x: 64, y: 0, width: 1856, height: 1080))
    }

    @Test func usableAreaExcludesATrailingBar() {
        let trailingBar = CGRect(x: 1856, y: 0, width: 64, height: 1080)

        let usable = WindowOverlapPolicy.usableArea(of: display, excluding: trailingBar)

        #expect(usable == CGRect(x: 0, y: 0, width: 1856, height: 1080))
    }

    @Test func aBarOnAnotherDisplayLeavesTheUsableAreaWhole() {
        let elsewhere = CGRect(x: 3000, y: 0, width: 1920, height: 48)

        let usable = WindowOverlapPolicy.usableArea(of: display, excluding: elsewhere)

        #expect(usable == display.frame)
    }

    @Test func aWindowAlreadyCorrectedIsNotCorrectedAgain() {
        let corrected = WindowOverlapPolicy.correctedFrame(
            for: window(CGRect(x: 0, y: 0, width: 1920, height: 1080)),
            barFrame: bottomBar,
            display: display
        )
        let secondPass = WindowOverlapPolicy.correctedFrame(
            for: window(corrected!),
            barFrame: bottomBar,
            display: display
        )

        #expect(secondPass == nil)
    }
}
