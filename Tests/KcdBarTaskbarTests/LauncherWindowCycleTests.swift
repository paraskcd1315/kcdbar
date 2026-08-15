import CoreGraphics
import Testing

@testable import KcdBarTaskbar

struct LauncherWindowCycleTests {
    private let left = DisplayGeometry(
        id: 1,
        frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
        isPrimary: true
    )
    private let right = DisplayGeometry(
        id: 2,
        frame: CGRect(x: 1920, y: 0, width: 1920, height: 1080),
        isPrimary: false
    )

    private var displays: [DisplayGeometry] { [left, right] }

    private func window(
        _ id: UInt32,
        pid: pid_t,
        on display: DisplayGeometry,
        zOrder: Int,
        minimized: Bool = false
    ) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: pid, cgWindowId: id, fallbackKey: "\(pid):\(id)"),
            ownerPid: pid,
            ownerName: "app",
            title: "w\(id)",
            bounds: CGRect(x: display.frame.minX + 10, y: 10, width: 800, height: 600),
            isMinimized: minimized,
            isFullScreen: false,
            isOnScreen: true,
            zOrder: zOrder,
            source: .both
        )
    }

    @Test func anApplicationWithNoWindowHasNothingToRaise() {
        let chosen = LauncherWindowCycle.next(
            pids: [7],
            onDisplay: 1,
            among: [window(1, pid: 9, on: left, zOrder: 0)],
            displays: displays,
            frontmostPid: nil
        )

        #expect(chosen == nil)
    }

    @Test func theDisplayClickedOnWinsOverEveryOther() {
        let here = window(2, pid: 7, on: right, zOrder: 1)
        let chosen = LauncherWindowCycle.next(
            pids: [7],
            onDisplay: 2,
            among: [window(1, pid: 7, on: left, zOrder: 0), here],
            displays: displays,
            frontmostPid: nil
        )

        #expect(chosen == here)
    }

    @Test func aDisplayWithNoneOfItsWindowsFallsBackToTheRest() {
        let elsewhere = window(1, pid: 7, on: left, zOrder: 0)
        let chosen = LauncherWindowCycle.next(
            pids: [7],
            onDisplay: 2,
            among: [elsewhere],
            displays: displays,
            frontmostPid: nil
        )

        #expect(chosen == elsewhere)
    }

    @Test func aSecondClickMovesToTheNextWindow() {
        let front = window(1, pid: 7, on: left, zOrder: 0)
        let behind = window(2, pid: 7, on: left, zOrder: 1)
        let chosen = LauncherWindowCycle.next(
            pids: [7],
            onDisplay: 1,
            among: [front, behind],
            displays: displays,
            frontmostPid: 7
        )

        #expect(chosen == behind)
    }

    @Test func theLastWindowWrapsBackToTheFirst() {
        let first = window(1, pid: 7, on: left, zOrder: 1)
        let last = window(2, pid: 7, on: left, zOrder: 0)
        let chosen = LauncherWindowCycle.next(
            pids: [7],
            onDisplay: 1,
            among: [first, last],
            displays: displays,
            frontmostPid: 7
        )

        #expect(chosen == first)
    }

    @Test func severalProcessesOfOneApplicationCycleTogether() {
        let one = window(1, pid: 7, on: left, zOrder: 0)
        let two = window(2, pid: 8, on: left, zOrder: 1)
        let chosen = LauncherWindowCycle.next(
            pids: [7, 8],
            onDisplay: 1,
            among: [one, two],
            displays: displays,
            frontmostPid: 7
        )

        #expect(chosen == two)
    }
}
