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
import Testing
@testable import KcdBarTaskbar

struct WindowReconcilerTests {
    @Test func matchesByBridgedWindowIdAndReportsBothSources() {
        let cg = WindowFixtures.cgRecord(windowId: 10, pid: 1, title: "Document")
        let ax = WindowFixtures.axRecord(pid: 1, cgWindowId: 10, title: "Document")

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .both)
        #expect(result[0].identity.cgWindowId == 10)
        #expect(result[0].isMinimized == false)
    }

    @Test func promotesMinimizedWindowKnownOnlyToAccessibility() {
        let ax = WindowFixtures.axRecord(pid: 1, cgWindowId: nil, title: "Hidden", isMinimized: true)

        let result = WindowReconciler.reconcile(coreGraphics: [], accessibility: .answered([ax]), previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .accessibilityOnly)
        #expect(result[0].isMinimized)
        #expect(result[0].isOnScreen == false)
    }

    @Test func doesNotPromoteNonMinimizedWindowAccessibilityAloneReports() {
        let ax = WindowFixtures.axRecord(pid: 1, cgWindowId: nil, title: "Ghost", isMinimized: false)

        let result = WindowReconciler.reconcile(coreGraphics: [], accessibility: .answered([ax]), previous: [])

        #expect(result.isEmpty)
    }

    @Test func keepsWindowCoreGraphicsAloneReportsButMarksTheSource() {
        let cg = WindowFixtures.cgRecord(windowId: 11, pid: 2, title: nil)

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .silent, previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .coreGraphicsOnly)
        #expect(WindowPresentationPolicy.isTaskbarEntry(result[0]) == false)
    }

    @Test func keepsAConfirmedWindowWhenAccessibilityAnswersNothingThisPass() {
        let cg = WindowFixtures.cgRecord(windowId: 20, pid: 5, title: "Console")
        let ax = WindowFixtures.axRecord(pid: 5, cgWindowId: 20, title: "Console")
        let confirmed = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])

        let silent = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .silent, previous: confirmed)

        #expect(silent.count == 1)
        #expect(silent[0].source == .both)
        #expect(WindowPresentationPolicy.isTaskbarEntry(silent[0]))
    }

    @Test func keepsAConfirmedWindowMinimizedWhileAccessibilityIsSilent() {
        let cg = WindowFixtures.cgRecord(windowId: 21, pid: 6, title: "Console")
        let ax = WindowFixtures.axRecord(pid: 6, cgWindowId: 21, title: "Console", isMinimized: true)
        let confirmed = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])

        let silent = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .silent, previous: confirmed)

        #expect(silent[0].isMinimized)
    }

    @Test func dropsAConfirmedWindowWhenItsApplicationAnswersWithoutIt() {
        let closed = WindowFixtures.cgRecord(windowId: 30, pid: 8, title: "Closed", isOnScreen: false, zOrder: 0)
        let open = WindowFixtures.cgRecord(windowId: 31, pid: 8, title: "Open", zOrder: 1)
        let confirmed = WindowReconciler.reconcile(
            coreGraphics: [closed, open],
            accessibility: .answered([
                WindowFixtures.axRecord(pid: 8, cgWindowId: 30, title: "Closed"),
                WindowFixtures.axRecord(pid: 8, cgWindowId: 31, title: "Open", indexInApplication: 1)
            ]),
            previous: []
        )

        let now = WindowReconciler.reconcile(
            coreGraphics: [closed, open],
            accessibility: .answered([WindowFixtures.axRecord(pid: 8, cgWindowId: 31, title: "Open")]),
            previous: confirmed
        )

        #expect(confirmed.filter(WindowPresentationPolicy.isTaskbarEntry).count == 2)
        #expect(WindowPresentationPolicy.taskbarEntries(from: now).map(\.title) == ["Open"])
    }

    @Test func doesNotFallBackToBoundsForARecordThatNamesADifferentWindowId() {
        let cg = WindowFixtures.cgRecord(windowId: 40, pid: 12, title: "Closed")
        let ax = WindowFixtures.axRecord(pid: 12, cgWindowId: 41, title: "Open")

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .coreGraphicsOnly)
    }

    @Test func keepsAConfirmedWindowTheApplicationOmittedWhileCoreGraphicsShowsItOnScreen() {
        let shown = WindowFixtures.cgRecord(windowId: 34, pid: 9, title: "Shown", isOnScreen: true)
        let confirmed = WindowReconciler.reconcile(
            coreGraphics: [shown],
            accessibility: .answered([WindowFixtures.axRecord(pid: 9, cgWindowId: 34, title: "Shown")]),
            previous: []
        )

        let omitted = WindowReconciler.reconcile(
            coreGraphics: [shown],
            accessibility: AxWindowScan(records: [], answeredPids: [9]),
            previous: confirmed
        )

        #expect(omitted[0].source == .both)
        #expect(WindowPresentationPolicy.isTaskbarEntry(omitted[0]))
    }

    @Test func dropsEveryConfirmedWindowWhenTheApplicationAnswersWithNone() {
        let cg = WindowFixtures.cgRecord(windowId: 32, pid: 9, title: "Closed", isOnScreen: false)
        let confirmed = WindowReconciler.reconcile(
            coreGraphics: [cg],
            accessibility: .answered([WindowFixtures.axRecord(pid: 9, cgWindowId: 32, title: "Closed")]),
            previous: []
        )

        let now = WindowReconciler.reconcile(
            coreGraphics: [cg],
            accessibility: AxWindowScan(records: [], answeredPids: [9]),
            previous: confirmed
        )

        #expect(now[0].source == .coreGraphicsOnly)
        #expect(WindowPresentationPolicy.taskbarEntries(from: now).isEmpty)
    }

    @Test func anotherApplicationAnsweringDoesNotDropASilentApplicationsEntry() {
        let cg = WindowFixtures.cgRecord(windowId: 33, pid: 10, title: "Busy")
        let confirmed = WindowReconciler.reconcile(
            coreGraphics: [cg],
            accessibility: .answered([WindowFixtures.axRecord(pid: 10, cgWindowId: 33, title: "Busy")]),
            previous: []
        )

        let now = WindowReconciler.reconcile(
            coreGraphics: [cg],
            accessibility: AxWindowScan(records: [], answeredPids: [11]),
            previous: confirmed
        )

        #expect(now[0].source == .both)
        #expect(WindowPresentationPolicy.isTaskbarEntry(now[0]))
    }

    @Test func stillReportsCoreGraphicsOnlyForAWindowAccessibilityNeverConfirmed() {
        let cg = WindowFixtures.cgRecord(windowId: 22, pid: 7, title: nil)
        let first = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .silent, previous: [])

        let second = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .silent, previous: first)

        #expect(second[0].source == .coreGraphicsOnly)
        #expect(WindowPresentationPolicy.isTaskbarEntry(second[0]) == false)
    }

    @Test func matchesByTitleWhenTheBridgeGivesNoWindowId() {
        let cg = WindowFixtures.cgRecord(windowId: 12, pid: 3, title: "Notes")
        let ax = WindowFixtures.axRecord(pid: 3, cgWindowId: nil, title: "Notes", isMinimized: false)

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .both)
    }

    @Test func matchesByBoundsWhenTitlesAreAbsent() {
        let bounds = CGRect(x: 100, y: 200, width: 800, height: 600)
        let cg = WindowFixtures.cgRecord(windowId: 13, pid: 4, title: nil, bounds: bounds)
        let ax = WindowFixtures.axRecord(pid: 4, cgWindowId: nil, title: nil, bounds: bounds)

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])

        #expect(result[0].source == .both)
    }

    @Test func toleratesSmallBoundsDrift() {
        let cgBounds = CGRect(x: 100, y: 200, width: 800, height: 600)
        let axBounds = CGRect(x: 102, y: 201, width: 800, height: 600)
        let cg = WindowFixtures.cgRecord(windowId: 14, pid: 5, title: nil, bounds: cgBounds)
        let ax = WindowFixtures.axRecord(pid: 5, cgWindowId: nil, title: nil, bounds: axBounds)

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])

        #expect(result[0].source == .both)
    }

    @Test func doesNotMatchAcrossProcesses() {
        let bounds = CGRect(x: 0, y: 0, width: 800, height: 600)
        let cg = WindowFixtures.cgRecord(windowId: 15, pid: 6, title: "Same", bounds: bounds)
        let ax = WindowFixtures.axRecord(pid: 7, cgWindowId: nil, title: "Same", bounds: bounds)

        let result = WindowReconciler.reconcile(coreGraphics: [cg], accessibility: .answered([ax]), previous: [])

        #expect(result.count == 1)
        #expect(result[0].source == .coreGraphicsOnly)
    }

    @Test func identitySurvivesATitleChange() {
        let before = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 16, pid: 8, title: "Untitled")],
            accessibility: .answered([WindowFixtures.axRecord(pid: 8, cgWindowId: 16, title: "Untitled")]),
            previous: []
        )
        let after = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 16, pid: 8, title: "Report.pdf")],
            accessibility: .answered([WindowFixtures.axRecord(pid: 8, cgWindowId: 16, title: "Report.pdf")]),
            previous: before
        )

        #expect(before[0].identity == after[0].identity)
        #expect(after[0].title == "Report.pdf")
    }

    @Test func minimizedWindowKeepsTheIdentityItHadWhileOnScreen() {
        let onScreen = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 17, pid: 9, title: "Inbox")],
            accessibility: .answered([WindowFixtures.axRecord(pid: 9, cgWindowId: nil, title: "Inbox")]),
            previous: []
        )
        let minimized = WindowReconciler.reconcile(
            coreGraphics: [],
            accessibility: .answered([WindowFixtures.axRecord(pid: 9, cgWindowId: nil, title: "Inbox", isMinimized: true)]),
            previous: onScreen
        )

        #expect(minimized.count == 1)
        #expect(minimized[0].identity == onScreen[0].identity)
    }

    @Test func keepsTheLastKnownTitleWhenNeitherSourceReportsOne() {
        let previous = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 18, pid: 10, title: "Session")],
            accessibility: .answered([WindowFixtures.axRecord(pid: 10, cgWindowId: 18, title: "Session")]),
            previous: []
        )
        let now = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 18, pid: 10, title: nil)],
            accessibility: .answered([WindowFixtures.axRecord(pid: 10, cgWindowId: 18, title: nil)]),
            previous: previous
        )

        #expect(now[0].title == "Session")
    }

    @Test func processThatDiesMidSweepLeavesNoEntry() {
        let previous = WindowReconciler.reconcile(
            coreGraphics: [WindowFixtures.cgRecord(windowId: 19, pid: 11, title: "Gone")],
            accessibility: .answered([WindowFixtures.axRecord(pid: 11, cgWindowId: 19, title: "Gone")]),
            previous: []
        )

        let result = WindowReconciler.reconcile(coreGraphics: [], accessibility: .silent, previous: previous)

        #expect(result.isEmpty)
    }

    @Test func consumesEachAccessibilityRecordOnlyOnce() {
        let bounds = CGRect(x: 0, y: 0, width: 800, height: 600)
        let first = WindowFixtures.cgRecord(windowId: 20, pid: 12, title: nil, bounds: bounds, zOrder: 0)
        let second = WindowFixtures.cgRecord(windowId: 21, pid: 12, title: nil, bounds: bounds, zOrder: 1)
        let ax = WindowFixtures.axRecord(pid: 12, cgWindowId: nil, title: nil, bounds: bounds)

        let result = WindowReconciler.reconcile(coreGraphics: [first, second], accessibility: .answered([ax]), previous: [])

        #expect(result.filter { $0.source == .both }.count == 1)
        #expect(result.filter { $0.source == .coreGraphicsOnly }.count == 1)
    }

    @Test func keepsTheEntryOfAWindowTheApplicationOmittedWhileItsElementStillAnswers() {
        let cg = WindowFixtures.cgRecord(windowId: 40, pid: 20, title: "Another Space")
        let confirmed = WindowReconciler.reconcile(
            coreGraphics: [cg],
            accessibility: .answered([WindowFixtures.axRecord(pid: 20, cgWindowId: 40, title: "Another Space")]),
            previous: []
        )

        let now = WindowReconciler.reconcile(
            coreGraphics: [cg],
            accessibility: AxWindowScan(records: [], answeredPids: [20], liveOmittedIds: [40]),
            previous: confirmed
        )

        #expect(now[0].source == .both)
        #expect(WindowPresentationPolicy.isTaskbarEntry(now[0]))
    }

    @Test func dropsTheEntryOfAClosedWindowCoreGraphicsStillReports() {
        let cg = WindowFixtures.cgRecord(windowId: 41, pid: 21, title: "Closed Scene", isOnScreen: false)
        let confirmed = WindowReconciler.reconcile(
            coreGraphics: [cg],
            accessibility: .answered([WindowFixtures.axRecord(pid: 21, cgWindowId: 41, title: "Closed Scene")]),
            previous: []
        )

        let now = WindowReconciler.reconcile(
            coreGraphics: [cg],
            accessibility: AxWindowScan(records: [], answeredPids: [21], liveOmittedIds: []),
            previous: confirmed
        )

        #expect(now[0].source == .coreGraphicsOnly)
        #expect(WindowPresentationPolicy.taskbarEntries(from: now).isEmpty)
    }

    @Test func keepsOnlyTheOmittedWindowsWhoseElementAnswered() {
        let onAnotherSpace = WindowFixtures.cgRecord(windowId: 42, pid: 22, title: "Desktop", zOrder: 0)
        let closed = WindowFixtures.cgRecord(windowId: 43, pid: 22, title: "Closed", isOnScreen: false, zOrder: 1)
        let confirmed = WindowReconciler.reconcile(
            coreGraphics: [onAnotherSpace, closed],
            accessibility: .answered([
                WindowFixtures.axRecord(pid: 22, cgWindowId: 42, title: "Desktop"),
                WindowFixtures.axRecord(pid: 22, cgWindowId: 43, title: "Closed", indexInApplication: 1)
            ]),
            previous: []
        )

        let now = WindowReconciler.reconcile(
            coreGraphics: [onAnotherSpace, closed],
            accessibility: AxWindowScan(records: [], answeredPids: [22], liveOmittedIds: [42]),
            previous: confirmed
        )

        #expect(WindowPresentationPolicy.taskbarEntries(from: now).map(\.identity.cgWindowId) == [42])
    }

    @Test func neverMakesAnEntryOfAWindowAccessibilityHasNotConfirmed() {
        let cg = WindowFixtures.cgRecord(windowId: 44, pid: 23, title: "Helper")

        let now = WindowReconciler.reconcile(
            coreGraphics: [cg],
            accessibility: AxWindowScan(records: [], answeredPids: [23], liveOmittedIds: [44]),
            previous: []
        )

        #expect(now[0].source == .coreGraphicsOnly)
        #expect(WindowPresentationPolicy.taskbarEntries(from: now).isEmpty)
    }
}
