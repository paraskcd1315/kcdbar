import CoreGraphics
import Foundation
import Testing

@testable import KcdBarTaskbar

@MainActor
struct SoloWindowEnforcerTests {
    private let left = DisplayGeometry(
        id: 1,
        frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
        isPrimary: true
    )
    private let start = Date(timeIntervalSince1970: 1_000)

    private func window(_ id: UInt32, pid: pid_t, zOrder: Int, minimized: Bool = false) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: pid, cgWindowId: id, fallbackKey: "\(pid):\(id)"),
            ownerPid: pid,
            ownerName: "app",
            title: "w\(id)",
            bounds: CGRect(x: 10, y: 10, width: 800, height: 600),
            isMinimized: minimized,
            isFullScreen: false,
            isOnScreen: true,
            zOrder: zOrder,
            source: .both
        )
    }

    private func enforcer(_ control: RecordingWindowControl) -> SoloWindowEnforcer {
        SoloWindowEnforcer(control: control, isEnabled: { true })
    }

    @Test func aWindowIsNotMinimisedWithinItsGracePeriod() {
        let control = RecordingWindowControl()
        let focused = window(1, pid: 10, zOrder: 0)
        let sibling = window(2, pid: 20, zOrder: 1)

        enforcer(control).enforce(
            frontmostPid: 10,
            windows: [focused, sibling],
            displays: [left],
            now: start
        )

        #expect(control.performed.isEmpty)
    }

    @Test func aSettledWindowIsMinimisedOnce() {
        let control = RecordingWindowControl()
        let subject = enforcer(control)
        let focused = window(1, pid: 10, zOrder: 0)
        let sibling = window(2, pid: 20, zOrder: 1)

        subject.enforce(frontmostPid: 10, windows: [focused, sibling], displays: [left], now: start)
        subject.enforce(
            frontmostPid: 20,
            windows: [focused, sibling],
            displays: [left],
            now: start + SoloWindowMetrics.grace
        )

        #expect(control.performed.map(\.1) == [focused.identity])
    }

    @Test func theSweepDoesNotRunAgainWhileFocusStaysPut() {
        let control = RecordingWindowControl()
        let subject = enforcer(control)
        let focused = window(1, pid: 10, zOrder: 0)
        let sibling = window(2, pid: 20, zOrder: 1)
        let settled = start + SoloWindowMetrics.grace

        subject.enforce(frontmostPid: 10, windows: [focused, sibling], displays: [left], now: start)
        subject.enforce(frontmostPid: 20, windows: [focused, sibling], displays: [left], now: settled)
        subject.enforce(frontmostPid: 20, windows: [focused, sibling], displays: [left], now: settled + 60)

        #expect(control.performed.count == 1)
    }

    @Test func aDisplayLeftBareHandsBackWhatItDisplaced() {
        let control = RecordingWindowControl()
        let subject = enforcer(control)
        let focused = window(1, pid: 10, zOrder: 0)
        let sibling = window(2, pid: 20, zOrder: 1)
        let settled = start + SoloWindowMetrics.grace

        subject.enforce(frontmostPid: 10, windows: [focused, sibling], displays: [left], now: start)
        subject.enforce(frontmostPid: 20, windows: [focused, sibling], displays: [left], now: settled)

        let asleep = window(1, pid: 10, zOrder: 1, minimized: true)
        subject.enforce(
            frontmostPid: 20,
            windows: [asleep, window(2, pid: 20, zOrder: 0)],
            displays: [left],
            now: settled + 1
        )

        #expect(control.performed.map(\.0) == [.minimize])
    }

    @Test func nothingIsTouchedWhileTheSweepIsSwitchedOff() {
        let control = RecordingWindowControl()
        let subject = SoloWindowEnforcer(control: control, isEnabled: { false })
        let focused = window(1, pid: 10, zOrder: 0)
        let sibling = window(2, pid: 20, zOrder: 1)

        subject.enforce(frontmostPid: 10, windows: [focused, sibling], displays: [left], now: start)
        subject.enforce(
            frontmostPid: 20,
            windows: [focused, sibling],
            displays: [left],
            now: start + SoloWindowMetrics.grace
        )

        #expect(control.performed.isEmpty)
    }
}
