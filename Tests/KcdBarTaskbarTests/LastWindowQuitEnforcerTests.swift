// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import CoreGraphics
import Foundation
import Testing
@testable import KcdBarTaskbar

@MainActor
struct LastWindowQuitEnforcerTests {
    private let now = Date(timeIntervalSinceReferenceDate: 800_000_000)
    private let editor = RunningApplication(
        pid: 10, bundleIdentifier: "com.example.editor", localizedName: "Editor",
        launchedAt: Date(timeIntervalSinceReferenceDate: 800_000_000 - 60))

    private func window(
        _ id: CGWindowID, pid: pid_t, source: WindowRecordSource = .both
    ) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: pid, cgWindowId: id, fallbackKey: "\(pid):\(id)"),
            ownerPid: pid, ownerName: "Editor", title: "Doc",
            bounds: .zero, isMinimized: false, isFullScreen: false, isOnScreen: true,
            zOrder: 0, source: source)
    }

    private func enforcer(
        _ terminator: RecordingApplicationTerminator,
        enabled: Bool = true,
        excluded: Set<String> = [],
        menuExtra: Bool? = false
    ) -> LastWindowQuitEnforcer {
        LastWindowQuitEnforcer(
            terminator: terminator,
            menuExtras: StubMenuExtraOwnership(answer: menuExtra),
            isEnabled: { enabled },
            excluded: { excluded }
        )
    }

    @Test func theLastWindowLeavingCoreGraphicsQuitsTheApplicationOnTheNextRefresh() {
        let terminator = RecordingApplicationTerminator()
        let enforcer = enforcer(terminator)

        enforcer.enforce(windows: [window(1, pid: 10)], applications: [editor], now: now)
        let decisions = enforcer.enforce(windows: [], applications: [editor], now: now)

        #expect(terminator.quit == ["com.example.editor"])
        #expect(decisions.map(\.verdict) == [.quit])
    }

    @Test func aWindowTheRegistryDemotedToCoreGraphicsOnlyIsAHiddenWindowAndTheApplicationIsQuit() {
        let terminator = RecordingApplicationTerminator()
        let enforcer = enforcer(terminator)

        enforcer.enforce(windows: [window(1, pid: 10)], applications: [editor], now: now)
        let hidden = enforcer.enforce(
            windows: [window(1, pid: 10, source: .coreGraphicsOnly)], applications: [editor], now: now)
        let gone = enforcer.enforce(windows: [], applications: [editor], now: now)

        #expect(hidden.map(\.verdict) == [.quit])
        #expect(gone.isEmpty)
        #expect(terminator.quit == ["com.example.editor"])
    }

    @Test func aWindowThatMovedToAnInactiveSpaceStillCounts() {
        let terminator = RecordingApplicationTerminator()
        let enforcer = enforcer(terminator)

        enforcer.enforce(windows: [window(1, pid: 10)], applications: [editor], now: now)
        let moved = enforcer.enforce(
            windows: [window(1, pid: 10, source: .inactiveSpace)], applications: [editor], now: now)

        #expect(moved.isEmpty)
        #expect(terminator.quit.isEmpty)
    }

    @Test func aWindowAccessibilityNeverConfirmedIsNotCounted() {
        let terminator = RecordingApplicationTerminator()
        let enforcer = enforcer(terminator)

        enforcer.enforce(
            windows: [window(1, pid: 10, source: .coreGraphicsOnly)], applications: [editor], now: now)
        let decisions = enforcer.enforce(windows: [], applications: [editor], now: now)

        #expect(decisions.isEmpty)
        #expect(terminator.quit.isEmpty)
    }

    @Test func aWindowClosingWhileAnotherStaysQuitsNothing() {
        let terminator = RecordingApplicationTerminator()
        let enforcer = enforcer(terminator)

        enforcer.enforce(windows: [window(1, pid: 10), window(2, pid: 10)], applications: [editor], now: now)
        enforcer.enforce(windows: [window(2, pid: 10)], applications: [editor], now: now)

        #expect(terminator.quit.isEmpty)
    }

    @Test func theFirstRefreshAfterLaunchQuitsNothing() {
        let terminator = RecordingApplicationTerminator()
        let enforcer = enforcer(terminator)

        enforcer.enforce(windows: [], applications: [editor], now: now)

        #expect(terminator.quit.isEmpty)
    }

    @Test func disabledItStillFollowsTheCountsSoEnablingLaterQuitsNothingAlreadyClosed() {
        let terminator = RecordingApplicationTerminator()
        var enabled = false
        let enforcer = LastWindowQuitEnforcer(
            terminator: terminator,
            menuExtras: StubMenuExtraOwnership(answer: false),
            isEnabled: { enabled },
            excluded: { [] }
        )

        enforcer.enforce(windows: [window(1, pid: 10)], applications: [editor], now: now)
        enforcer.enforce(windows: [], applications: [editor], now: now)
        enabled = true
        enforcer.enforce(windows: [], applications: [editor], now: now)

        #expect(terminator.quit.isEmpty)
    }

    @Test func aKeptApplicationIsReportedWithItsReason() {
        let terminator = RecordingApplicationTerminator()
        let enforcer = enforcer(terminator, menuExtra: true)

        enforcer.enforce(windows: [window(1, pid: 10)], applications: [editor], now: now)
        let decisions = enforcer.enforce(windows: [], applications: [editor], now: now)

        #expect(terminator.quit.isEmpty)
        #expect(decisions.map(\.verdict) == [.menuExtra])
    }
}
