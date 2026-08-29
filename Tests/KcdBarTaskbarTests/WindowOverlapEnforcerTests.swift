import CoreGraphics
import Foundation
import Testing

@testable import KcdBarTaskbar

@MainActor
struct WindowOverlapEnforcerTests {
    private let display = DisplayGeometry(
        id: 1,
        frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
        isPrimary: true
    )

    private func zoomedWindow(isOnScreen: Bool = true) -> ManagedWindow {
        let bounds = CGRect(x: 0, y: 0, width: 1920, height: 1080)
        let cg = WindowFixtures.cgRecord(windowId: 1, pid: 1, title: "W", bounds: bounds, isOnScreen: isOnScreen)
        let ax = WindowFixtures.axRecord(pid: 1, cgWindowId: 1, title: "W", bounds: bounds)

        return WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])[0]
    }

    @Test func aWindowCoreGraphicsReportsOffScreenIsLeftAlone() {
        let control = RecordingWindowControl()
        let enforcer = WindowOverlapEnforcer(control: control)

        enforcer.enforce(
            preset: BarPresetCatalogue.windows11,
            windows: [zoomedWindow(isOnScreen: false)],
            displays: [display],
            now: Date(timeIntervalSince1970: 0)
        )

        #expect(control.framed.isEmpty)
    }

    @Test func theSamePresetTwiceInsideTheIntervalCorrectsOnce() {
        let control = RecordingWindowControl()
        let enforcer = WindowOverlapEnforcer(control: control)
        let now = Date(timeIntervalSince1970: 0)
        let windows = [zoomedWindow()]

        enforcer.enforce(preset: BarPresetCatalogue.windows11, windows: windows, displays: [display], now: now)
        enforcer.enforce(
            preset: BarPresetCatalogue.windows11,
            windows: windows,
            displays: [display],
            now: now.addingTimeInterval(0.1)
        )

        #expect(control.framed.count == 1)
    }

    @Test func aChangedPresetCorrectsAtOnceRatherThanWaitingOutTheInterval() {
        let control = RecordingWindowControl()
        let enforcer = WindowOverlapEnforcer(control: control)
        let now = Date(timeIntervalSince1970: 0)
        let windows = [zoomedWindow()]

        enforcer.enforce(preset: BarPresetCatalogue.windows11, windows: windows, displays: [display], now: now)

        var thicker = BarPresetCatalogue.windows11
        thicker.thickness += 20
        enforcer.enforce(
            preset: thicker,
            windows: windows,
            displays: [display],
            now: now.addingTimeInterval(0.1)
        )

        #expect(control.framed.count == 2)
        #expect(control.framed.last?.0.minY == thicker.thickness)
    }
}
