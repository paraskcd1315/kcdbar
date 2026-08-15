import CoreGraphics
import Testing

@testable import KcdBarBar

struct SoloWindowPolicyTests {
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

    private func window(
        _ id: UInt32,
        pid: pid_t,
        on display: DisplayGeometry,
        zOrder: Int,
        minimized: Bool = false,
        fullScreen: Bool = false
    ) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: pid, cgWindowId: id, fallbackKey: "\(pid):\(id)"),
            ownerPid: pid,
            ownerName: "app",
            title: "w\(id)",
            bounds: CGRect(x: display.frame.minX + 10, y: 10, width: 800, height: 600),
            isMinimized: minimized,
            isFullScreen: fullScreen,
            isOnScreen: true,
            zOrder: zOrder,
            source: .both
        )
    }

    @Test func everySiblingOnTheFocusedDisplayIsMinimised() {
        let focused = window(1, pid: 10, on: left, zOrder: 0)
        let sibling = window(2, pid: 20, on: left, zOrder: 1)
        let toMinimise = SoloWindowPolicy.toMinimise(
            frontmostPid: 10,
            among: [focused, sibling],
            displays: [left, right]
        )

        #expect(toMinimise.map(\.identity) == [sibling.identity])
    }

    @Test func anotherDisplayKeepsItsWindow() {
        let focused = window(1, pid: 10, on: left, zOrder: 0)
        let elsewhere = window(2, pid: 20, on: right, zOrder: 1)
        let toMinimise = SoloWindowPolicy.toMinimise(
            frontmostPid: 10,
            among: [focused, elsewhere],
            displays: [left, right]
        )

        #expect(toMinimise.isEmpty)
    }

    @Test func anAlreadyMinimisedWindowIsLeftAlone() {
        let focused = window(1, pid: 10, on: left, zOrder: 0)
        let sleeping = window(2, pid: 20, on: left, zOrder: 1, minimized: true)
        let toMinimise = SoloWindowPolicy.toMinimise(
            frontmostPid: 10,
            among: [focused, sleeping],
            displays: [left, right]
        )

        #expect(toMinimise.isEmpty)
    }

    @Test func aFullScreenWindowIsLeftAlone() {
        let focused = window(1, pid: 10, on: left, zOrder: 0)
        let cinema = window(2, pid: 20, on: left, zOrder: 1, fullScreen: true)
        let toMinimise = SoloWindowPolicy.toMinimise(
            frontmostPid: 10,
            among: [focused, cinema],
            displays: [left, right]
        )

        #expect(toMinimise.isEmpty)
    }

    @Test func aSheetNeverMinimisesTheWindowItBelongsTo() {
        let parent = window(1, pid: 10, on: left, zOrder: 1)
        let sheet = window(2, pid: 10, on: left, zOrder: 0)
        let toMinimise = SoloWindowPolicy.toMinimise(
            frontmostPid: 10,
            among: [parent, sheet],
            displays: [left, right]
        )

        #expect(toMinimise.isEmpty)
    }

    @Test func nothingHappensWithoutAFocusedWindow() {
        let one = window(1, pid: 10, on: left, zOrder: 0)
        let two = window(2, pid: 20, on: left, zOrder: 1)
        let toMinimise = SoloWindowPolicy.toMinimise(
            frontmostPid: nil,
            among: [one, two],
            displays: [left, right]
        )

        #expect(toMinimise.isEmpty)
    }
}
