import CoreGraphics
import Testing
@testable import KcdBarBar

struct WindowFilteringTests {
    @Test func ignoresWindowsOutsideTheNormalLayer() {
        let panel = WindowFixtures.cgRecord(windowId: 30, pid: 20, title: "Menu", layer: 25)

        #expect(WindowReconciler.isManageable(panel) == false)
    }

    @Test func ignoresWindowsTooSmallToBeRealOnes() {
        let tooSmall = CGRect(x: 0, y: 0, width: 12, height: 12)
        let tooltip = WindowFixtures.cgRecord(windowId: 31, pid: 21, title: nil, bounds: tooSmall)

        #expect(WindowReconciler.isManageable(tooltip) == false)
    }

    @Test func keepsOrdinaryApplicationWindows() {
        let window = WindowFixtures.cgRecord(windowId: 32, pid: 22, title: "Document")

        #expect(WindowReconciler.isManageable(window))
    }

    @Test func taskbarShowsOnlyWindowsAccessibilityConfirms() {
        let confirmed = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 33, pid: 23, title: "Real")],
            accessibility: [WindowFixtures.axRecord(pid: 23, cgWindowId: 33, title: "Real")],
            previous: []
        )
        let helperSurface = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 34, pid: 24, title: nil)],
            accessibility: [],
            previous: []
        )

        #expect(WindowPresentationPolicy.taskbarEntries(from: confirmed).count == 1)
        #expect(WindowPresentationPolicy.taskbarEntries(from: helperSurface).isEmpty)
    }

    @Test func minimizedWindowsRemainTaskbarEntries() {
        let minimized = WindowReconciler.reconcile(
            coreGraphics: [],
            accessibility: [WindowFixtures.axRecord(pid: 25, cgWindowId: nil, title: "Away", isMinimized: true)],
            previous: []
        )

        #expect(WindowPresentationPolicy.taskbarEntries(from: minimized).count == 1)
    }
}
