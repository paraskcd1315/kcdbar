import CoreGraphics
import Testing
@testable import KcdBarTaskbar

struct WindowToggleTests {
    private func reconciled(
        _ records: [(pid: pid_t, id: CGWindowID, title: String, z: Int)],
        minimized: Set<CGWindowID> = []
    ) -> [ManagedWindow] {
        let cg = records
            .filter { !minimized.contains($0.id) }
            .map { WindowFixtures.cgRecord(windowId: $0.id, pid: $0.pid, title: $0.title, zOrder: $0.z) }
        let ax = records.map {
            WindowFixtures.axRecord(
                pid: $0.pid,
                cgWindowId: $0.id,
                title: $0.title,
                isMinimized: minimized.contains($0.id)
            )
        }
        return WindowReconciler.reconcile(coreGraphics: cg, accessibility: .answered(ax), previous: [])
    }

    @Test func frontWindowOfTheFrontmostApplicationMinimizes() {
        let windows = reconciled([(pid: 1, id: 10, title: "Front", z: 0)])

        let action = WindowToggleDecider.action(for: windows[0], frontmostPid: 1, among: windows)

        #expect(action == .minimize)
    }

    @Test func minimizedWindowRestores() {
        let windows = reconciled([(pid: 1, id: 10, title: "Away", z: 0)], minimized: [10])

        let action = WindowToggleDecider.action(for: windows[0], frontmostPid: 1, among: windows)

        #expect(action == .restore)
    }

    @Test func windowOfABackgroundApplicationRaises() {
        let windows = reconciled([
            (pid: 1, id: 10, title: "Front", z: 0),
            (pid: 2, id: 11, title: "Behind", z: 1)
        ])
        let behind = windows.first { $0.ownerPid == 2 }!

        let action = WindowToggleDecider.action(for: behind, frontmostPid: 1, among: windows)

        #expect(action == .raise)
    }

    @Test func siblingWindowOfTheFrontmostApplicationRaisesRatherThanMinimizing() {
        let windows = reconciled([
            (pid: 1, id: 10, title: "In front", z: 0),
            (pid: 1, id: 11, title: "Behind it", z: 3)
        ])
        let behind = windows.first { $0.identity.cgWindowId == 11 }!

        let action = WindowToggleDecider.action(for: behind, frontmostPid: 1, among: windows)

        #expect(action == .raise)
    }

    @Test func frontmostIsWindowLevelNotApplicationLevel() {
        let windows = reconciled([
            (pid: 1, id: 10, title: "In front", z: 0),
            (pid: 1, id: 11, title: "Behind it", z: 3)
        ])
        let front = windows.first { $0.identity.cgWindowId == 10 }!
        let behind = windows.first { $0.identity.cgWindowId == 11 }!

        #expect(WindowFocusPolicy.isFrontmost(front, frontmostPid: 1, among: windows))
        #expect(WindowFocusPolicy.isFrontmost(behind, frontmostPid: 1, among: windows) == false)
    }

    @Test func aMinimizedWindowIsNeverFrontmost() {
        let windows = reconciled([(pid: 1, id: 10, title: "Away", z: 0)], minimized: [10])

        #expect(WindowFocusPolicy.isFrontmost(windows[0], frontmostPid: 1, among: windows) == false)
    }

    @Test func minimizedSiblingsDoNotDecideWhichWindowIsInFront() {
        let windows = reconciled(
            [
                (pid: 1, id: 10, title: "Visible", z: 5),
                (pid: 1, id: 11, title: "Away", z: 0)
            ],
            minimized: [11]
        )
        let visible = windows.first { $0.identity.cgWindowId == 10 }!

        #expect(WindowFocusPolicy.isFrontmost(visible, frontmostPid: 1, among: windows))
    }

    @Test func aWindowWithoutAKnownStackingOrderIsNeverFrontmost() {
        let windows = reconciled([(pid: 1, id: 10, title: "Off screen", z: Int.max)])

        #expect(WindowFocusPolicy.isFrontmost(windows[0], frontmostPid: 1, among: windows) == false)
    }

    @Test func theFrontWindowWinsAmongSiblingsOfTheSameApplication() {
        let windows = reconciled([
            (pid: 1, id: 10, title: "Second", z: 4),
            (pid: 1, id: 11, title: "First", z: 1),
            (pid: 1, id: 12, title: "Third", z: 9)
        ])
        let first = windows.first { $0.identity.cgWindowId == 11 }!

        #expect(WindowFocusPolicy.isFrontmost(first, frontmostPid: 1, among: windows))
        #expect(windows.filter { WindowFocusPolicy.isFrontmost($0, frontmostPid: 1, among: windows) }.count == 1)
    }

    @Test func nothingIsFrontmostWhenNoApplicationIsFrontmost() {
        let windows = reconciled([(pid: 1, id: 10, title: "Front", z: 0)])

        #expect(WindowFocusPolicy.isFrontmost(windows[0], frontmostPid: nil, among: windows) == false)
    }
}
