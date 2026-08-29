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

import Foundation
import Testing

@testable import KcdBarTaskbar

struct DockSuppressionPolicyTests {
    private let now = Date(timeIntervalSinceReferenceDate: 800_000_000)

    private var theirs: DockSettingsSnapshot {
        DockSettingsSnapshot(
            autohide: false,
            autohideDelay: 0.5,
            autohideTimeModifier: 1,
            minimizeEffect: "genie",
            orientation: "bottom",
            tilesize: 64,
            largesize: 128,
            magnification: true
        )
    }

    private func decide(
        handling: DockHandling,
        captured: DockSettingsSnapshot? = nil,
        lastRestart: Date? = nil,
        at moment: Date? = nil
    ) -> DockDecision {
        DockSuppressionPolicy.decide(
            handling: handling,
            captured: captured,
            lastRestart: lastRestart,
            now: moment ?? now,
            current: { theirs }
        )
    }

    private func value(_ decision: DockDecision, forKey key: String) -> DockDefaultValue?? {
        decision.write.first { $0.key == key }?.value
    }

    @Test func hidingCapturesWhatTheDockHeldBeforeItChangesAnything() {
        let decision = decide(handling: .hide)

        #expect(decision.capture == theirs)
        #expect(decision.verdict == .suppressed)
    }

    @Test func hidingWritesTheFourDefaultsTheProductOwnsAndNoOthers() {
        let decision = decide(handling: .hide)

        #expect(decision.write.map(\.key) == [
            DockControlKeys.autohide,
            DockControlKeys.autohideDelay,
            DockControlKeys.autohideTimeModifier,
            DockControlKeys.minimizeEffect,
        ])
        #expect(value(decision, forKey: DockControlKeys.autohide) == .flag(true))
        #expect(value(decision, forKey: DockControlKeys.autohideDelay) == .number(1000))
        #expect(value(decision, forKey: DockControlKeys.autohideTimeModifier) == .number(0))
        #expect(value(decision, forKey: DockControlKeys.minimizeEffect) == .text("scale"))
    }

    @Test func hidingRestartsTheDockOnceAndKeepsTheSnapshot() {
        let decision = decide(handling: .hide)

        #expect(decision.restart)
        #expect(decision.forget == false)
    }

    @Test func aSecondHideOverAnExistingSnapshotChangesNothing() {
        let decision = decide(handling: .hide, captured: theirs)

        #expect(decision.verdict == .unchanged)
        #expect(decision.write.isEmpty)
        #expect(decision.restart == false)
        #expect(decision.capture == nil)
    }

    @Test func leavingItAloneWithNothingCapturedTouchesTheDockNotAtAll() {
        let decision = decide(handling: .leaveAlone)

        #expect(decision.verdict == .leftAlone)
        #expect(decision.write.isEmpty)
        #expect(decision.restart == false)
    }

    @Test func borrowingTheReservationRestoresWhatWasChanged() {
        let decision = decide(handling: .borrowReservation, captured: theirs)

        #expect(decision.verdict == .restored)
        #expect(decision.restart)
    }

    @Test func restoringPutsBackEveryValueTheSnapshotHeld() {
        let decision = decide(handling: .leaveAlone, captured: theirs)

        #expect(value(decision, forKey: DockControlKeys.autohide) == .flag(false))
        #expect(value(decision, forKey: DockControlKeys.autohideDelay) == .number(0.5))
        #expect(value(decision, forKey: DockControlKeys.autohideTimeModifier) == .number(1))
        #expect(value(decision, forKey: DockControlKeys.minimizeEffect) == .text("genie"))
    }

    @Test func aKeyTheUserNeverSetIsRemovedRatherThanLeftAtOurValue() {
        let decision = decide(handling: .leaveAlone, captured: DockSettingsSnapshot())

        #expect(decision.write.count == 4)
        #expect(decision.write.allSatisfy { $0.value == nil })
    }

    @Test func restoringForgetsTheSnapshotSoTheNextHideCapturesAfresh() {
        let decision = decide(handling: .leaveAlone, captured: theirs)

        #expect(decision.forget)
        #expect(decision.capture == nil)
    }

    @Test func restoringWithoutASnapshotIsNotARestore() {
        let decision = decide(handling: .borrowReservation)

        #expect(decision.verdict == .leftAlone)
        #expect(decision.write.isEmpty)
    }

    @Test func aRestartInsideTheFloorIsRefusedRatherThanQueuedIntoALoop() {
        let decision = decide(
            handling: .hide,
            lastRestart: now.addingTimeInterval(-1),
            at: now
        )

        #expect(decision.verdict == .tooSoon)
        #expect(decision.restart == false)
        #expect(decision.write.isEmpty)
        #expect(decision.capture == nil)
    }

    @Test func aRestartRefusedInsideTheFloorIsAllowedOnceTheFloorHasPassed() {
        let decision = decide(
            handling: .hide,
            lastRestart: now.addingTimeInterval(-DockMetrics.restartFloor),
            at: now
        )

        #expect(decision.verdict == .suppressed)
        #expect(decision.restart)
    }

    @Test func theFloorGuardsARestoreAsWellAsAHide() {
        let decision = decide(
            handling: .leaveAlone,
            captured: theirs,
            lastRestart: now.addingTimeInterval(-1),
            at: now
        )

        #expect(decision.verdict == .tooSoon)
        #expect(decision.forget == false)
    }

    @Test func nothingIsWrittenWhenNothingIsRestarted() {
        let refused = [
            decide(handling: .hide, captured: theirs),
            decide(handling: .leaveAlone),
            decide(handling: .hide, lastRestart: now, at: now),
        ]

        #expect(refused.allSatisfy { $0.restart == false && $0.write.isEmpty })
    }
}
