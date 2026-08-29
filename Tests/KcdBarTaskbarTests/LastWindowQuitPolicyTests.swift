import CoreGraphics
import Foundation
import Testing
@testable import KcdBarTaskbar

struct LastWindowQuitPolicyTests {
    private let now = Date(timeIntervalSinceReferenceDate: 800_000_000)

    private func application(
        _ pid: pid_t, bundle: String? = "com.example.editor", launchedAgo: TimeInterval = 60
    ) -> RunningApplication {
        RunningApplication(
            pid: pid, bundleIdentifier: bundle, localizedName: "Editor",
            launchedAt: now.addingTimeInterval(-launchedAgo))
    }

    private func window(
        _ id: CGWindowID, pid: pid_t, source: WindowRecordSource = .both
    ) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: pid, cgWindowId: id, fallbackKey: "\(pid):\(id)"),
            ownerPid: pid, ownerName: "Editor", title: "Doc",
            bounds: .zero, isMinimized: false, isFullScreen: false, isOnScreen: true,
            zOrder: 0, source: source)
    }

    @Test func countsAreTakenPerOwner() {
        let windows = [window(1, pid: 10), window(2, pid: 10), window(3, pid: 20)]

        #expect(LastWindowQuitPolicy.windowCounts(of: windows) == [10: 2, 20: 1])
    }

    @Test func aCoreGraphicsOnlyWindowIsNotCounted() {
        let windows = [window(1, pid: 10, source: .coreGraphicsOnly)]

        #expect(LastWindowQuitPolicy.windowCounts(of: windows).isEmpty)
    }

    @Test func aWindowOnAnInactiveSpaceIsCounted() {
        let windows = [window(1, pid: 10, source: .inactiveSpace)]

        #expect(LastWindowQuitPolicy.windowCounts(of: windows) == [10: 1])
    }

    @Test func aWindowAccessibilityListsWithoutACoreGraphicsIdIsCounted() {
        let minimized = ManagedWindow(
            identity: WindowIdentity(ownerPid: 10, cgWindowId: nil, fallbackKey: "10:ax0"),
            ownerPid: 10, ownerName: "Editor", title: "Doc",
            bounds: nil, isMinimized: true, isFullScreen: false, isOnScreen: false,
            zOrder: nil, source: .accessibilityOnly)

        #expect(LastWindowQuitPolicy.windowCounts(of: [minimized]) == [10: 1])
    }

    @Test func onlyAnApplicationWhoseCountFellToZeroIsClosedOut() {
        let closed = LastWindowQuitPolicy.closedOut(
            previous: [10: 1, 20: 2, 30: 1],
            current: [20: 1, 40: 1],
            among: [application(10), application(20), application(40)]
        )

        #expect(closed.map(\.pid) == [10])
    }

    @Test func anApplicationThatWasNeverSeenWithAWindowIsNotClosedOut() {
        let closed = LastWindowQuitPolicy.closedOut(
            previous: [:], current: [:], among: [application(10)])

        #expect(closed.isEmpty)
    }

    @Test func anOrdinaryApplicationWithNoMenuExtraIsQuit() {
        let verdict = LastWindowQuitPolicy.decide(application(10), excluded: [], now: now) { false }

        #expect(verdict == .quit)
    }

    @Test func theFinderIsNeverQuit() {
        let verdict = LastWindowQuitPolicy.decide(
            application(10, bundle: "com.apple.finder"), excluded: [], now: now) { false }

        #expect(verdict == .unquittable)
    }

    @Test func anExcludedApplicationIsKept() {
        let verdict = LastWindowQuitPolicy.decide(
            application(10), excluded: ["com.example.editor"], now: now) { false }

        #expect(verdict == .excluded)
    }

    @Test func anApplicationStillLaunchingIsKept() {
        let verdict = LastWindowQuitPolicy.decide(
            application(10, launchedAgo: 1), excluded: [], now: now) { false }

        #expect(verdict == .launching)
    }

    @Test func anApplicationWithAMenuExtraIsKept() {
        let verdict = LastWindowQuitPolicy.decide(application(10), excluded: [], now: now) { true }

        #expect(verdict == .menuExtra)
    }

    @Test func anApplicationThatDoesNotAnswerIsKept() {
        let verdict = LastWindowQuitPolicy.decide(application(10), excluded: [], now: now) { nil }

        #expect(verdict == .silent)
    }

    @Test func theMenuExtraIsOnlyAskedForOnceTheCheaperRulesPass() {
        var asked = false
        _ = LastWindowQuitPolicy.decide(
            application(10, bundle: "com.apple.dock"), excluded: [], now: now
        ) {
            asked = true
            return false
        }

        #expect(!asked)
    }
}
