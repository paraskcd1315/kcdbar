import CoreGraphics
import Foundation
import Testing

@testable import KcdBarTaskbar

@MainActor
struct OffSpaceWindowIsLeftAloneTests {
    private let display = DisplayGeometry(
        id: 1,
        frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
        isPrimary: true
    )

    private func entry(windowId: CGWindowID, pid: pid_t, zOrder: Int) -> ManagedWindow {
        let bounds = CGRect(x: 0, y: 0, width: 1920, height: 1080)
        let cg = WindowFixtures.cgRecord(
            windowId: windowId,
            pid: pid,
            title: "W\(windowId)",
            bounds: bounds,
            zOrder: zOrder
        )
        let ax = WindowFixtures.axRecord(pid: pid, cgWindowId: windowId, title: "W\(windowId)", bounds: bounds)

        return WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])[0]
    }

    @Test func theOverlapEnforcerMovesNoWindowOnAnotherSpace() {
        let control = RecordingWindowControl()
        let enforcer = WindowOverlapEnforcer(control: control)

        enforcer.enforce(
            preset: BarPresetCatalogue.windows11,
            windows: [entry(windowId: 1, pid: 1, zOrder: Int.max)],
            displays: [display],
            now: Date(timeIntervalSince1970: 0)
        )

        #expect(control.framed.isEmpty)
    }

    @Test func showDesktopHidesNoWindowOnAnotherSpace() {
        let here = entry(windowId: 2, pid: 2, zOrder: 0)
        let elsewhere = entry(windowId: 3, pid: 3, zOrder: Int.max)

        let hidden = ShowDesktopPlan.toHide(among: [here, elsewhere])

        #expect(hidden.map(\.identity.cgWindowId) == [2])
    }

    @Test func theSoloSweepMinimisesNoWindowOnAnotherSpace() {
        let focused = entry(windowId: 4, pid: 4, zOrder: 0)
        let elsewhere = entry(windowId: 5, pid: 5, zOrder: Int.max)

        let wanted = SoloWindowPolicy.toMinimise(
            frontmostPid: 4,
            among: [focused, elsewhere],
            displays: [display]
        )

        #expect(wanted.isEmpty)
    }
}
