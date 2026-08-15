import CoreGraphics
import Testing
@testable import KcdBarBar

struct WindowReconcilerTests {
    @Test func matchesByBridgedWindowIdAndReportsBothSources() {
        let cg = WindowFixtures.cgRecord(windowId: 10, pid: 1, title: "Document")
        let ax = WindowFixtures.axRecord(pid: 1, cgWindowId: 10, title: "Document")

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: [ax], previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .both)
        #expect(result[0].identity.cgWindowId == 10)
        #expect(result[0].isMinimized == false)
    }

    @Test func promotesMinimizedWindowKnownOnlyToAccessibility() {
        let ax = WindowFixtures.axRecord(pid: 1, cgWindowId: nil, title: "Hidden", isMinimized: true)

        let result = WindowReconciler.reconcile(coreGraphics: [], accessibility: [ax], previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .accessibilityOnly)
        #expect(result[0].isMinimized)
        #expect(result[0].isOnScreen == false)
    }

    @Test func doesNotPromoteNonMinimizedWindowAccessibilityAloneReports() {
        let ax = WindowFixtures.axRecord(pid: 1, cgWindowId: nil, title: "Ghost", isMinimized: false)

        let result = WindowReconciler.reconcile(coreGraphics: [], accessibility: [ax], previous: [])

        #expect(result.isEmpty)
    }

    @Test func keepsWindowCoreGraphicsAloneReportsButMarksTheSource() {
        let cg = WindowFixtures.cgRecord(windowId: 11, pid: 2, title: nil)

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: [], previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .coreGraphicsOnly)
        #expect(WindowPresentationPolicy.isTaskbarEntry(result[0]) == false)
    }

    @Test func matchesByTitleWhenTheBridgeGivesNoWindowId() {
        let cg = WindowFixtures.cgRecord(windowId: 12, pid: 3, title: "Notes")
        let ax = WindowFixtures.axRecord(pid: 3, cgWindowId: nil, title: "Notes", isMinimized: false)

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: [ax], previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .both)
    }

    @Test func matchesByBoundsWhenTitlesAreAbsent() {
        let bounds = CGRect(x: 100, y: 200, width: 800, height: 600)
        let cg = WindowFixtures.cgRecord(windowId: 13, pid: 4, title: nil, bounds: bounds)
        let ax = WindowFixtures.axRecord(pid: 4, cgWindowId: nil, title: nil, bounds: bounds)

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: [ax], previous: [])

        #expect(result[0].source == .both)
    }

    @Test func toleratesSmallBoundsDrift() {
        let cgBounds = CGRect(x: 100, y: 200, width: 800, height: 600)
        let axBounds = CGRect(x: 102, y: 201, width: 800, height: 600)
        let cg = WindowFixtures.cgRecord(windowId: 14, pid: 5, title: nil, bounds: cgBounds)
        let ax = WindowFixtures.axRecord(pid: 5, cgWindowId: nil, title: nil, bounds: axBounds)

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: [ax], previous: [])

        #expect(result[0].source == .both)
    }

    @Test func doesNotMatchAcrossProcesses() {
        let bounds = CGRect(x: 0, y: 0, width: 800, height: 600)
        let cg = WindowFixtures.cgRecord(windowId: 15, pid: 6, title: "Same", bounds: bounds)
        let ax = WindowFixtures.axRecord(pid: 7, cgWindowId: nil, title: "Same", bounds: bounds)

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: [ax], previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .coreGraphicsOnly)
    }

    @Test func identitySurvivesATitleChange() {
        let before = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 16, pid: 8, title: "Untitled")],
            accessibility: [WindowFixtures.axRecord(pid: 8, cgWindowId: 16, title: "Untitled")],
            previous: []
        )
        let after = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 16, pid: 8, title: "Report.pdf")],
            accessibility: [WindowFixtures.axRecord(pid: 8, cgWindowId: 16, title: "Report.pdf")],
            previous: before
        )

        #expect(before[0].identity == after[0].identity)
        #expect(after[0].title == "Report.pdf")
    }

    @Test func minimizedWindowKeepsTheIdentityItHadWhileOnScreen() {
        let onScreen = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 17, pid: 9, title: "Inbox")],
            accessibility: [WindowFixtures.axRecord(pid: 9, cgWindowId: nil, title: "Inbox")],
            previous: []
        )
        let minimized = WindowReconciler.reconcile(
            coreGraphics: [],
            accessibility: [WindowFixtures.axRecord(pid: 9, cgWindowId: nil, title: "Inbox", isMinimized: true)],
            previous: onScreen
        )

        #expect(minimized.count == 1)
        #expect(minimized[0].identity == onScreen[0].identity)
    }

    @Test func keepsTheLastKnownTitleWhenNeitherSourceReportsOne() {
        let previous = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 18, pid: 10, title: "Session")],
            accessibility: [WindowFixtures.axRecord(pid: 10, cgWindowId: 18, title: "Session")],
            previous: []
        )
        let now = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 18, pid: 10, title: nil)],
            accessibility: [WindowFixtures.axRecord(pid: 10, cgWindowId: 18, title: nil)],
            previous: previous
        )

        #expect(now[0].title == "Session")
    }

    @Test func processThatDiesMidSweepLeavesNoEntry() {
        let previous = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 19, pid: 11, title: "Gone")],
            accessibility: [WindowFixtures.axRecord(pid: 11, cgWindowId: 19, title: "Gone")],
            previous: []
        )

        let result = WindowReconciler.reconcile(coreGraphics: [], accessibility: [], previous: previous)

        #expect(result.isEmpty)
    }

    @Test func consumesEachAccessibilityRecordOnlyOnce() {
        let bounds = CGRect(x: 0, y: 0, width: 800, height: 600)
        let first = WindowFixtures.cgRecord(windowId: 20, pid: 12, title: nil, bounds: bounds, zOrder: 0)
        let second = WindowFixtures.cgRecord(windowId: 21, pid: 12, title: nil, bounds: bounds, zOrder: 1)
        let ax = WindowFixtures.axRecord(pid: 12, cgWindowId: nil, title: nil, bounds: bounds)

        let result = WindowReconciler.reconcile(coreGraphics: [first, second], accessibility: [ax], previous: [])

        #expect(result.filter { $0.source == .both }.count == 1)
        #expect(result.filter { $0.source == .coreGraphicsOnly }.count == 1)
    }
}
