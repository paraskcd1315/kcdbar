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

import Testing

@testable import KcdBarTaskbar

struct BarPanelVisibilityStateTests {
    @Test func aHiddenDisplayIsNotWantedShown() {
        var state = BarPanelVisibilityState()
        state.setHidden([1])

        #expect(!state.wantsShown(1))
    }

    @Test func aHiddenAndRevealedDisplayIsWantedShown() {
        var state = BarPanelVisibilityState()
        state.setHidden([1])
        state.setRevealed(true, for: 1)

        #expect(state.wantsShown(1))
    }

    @Test func aDisplayThatIsNotHiddenIsWantedShown() {
        var state = BarPanelVisibilityState()
        state.setHidden([2])

        #expect(state.wantsShown(1))
    }

    @Test func setHiddenDropsARevealForADisplayThatIsNoLongerHidden() {
        var state = BarPanelVisibilityState()
        state.setHidden([1, 2])
        state.setRevealed(true, for: 1)
        state.setRevealed(true, for: 2)
        state.setHidden([2])

        #expect(state.revealed == [2])
        #expect(state.wantsShown(1))
        #expect(state.wantsShown(2))
    }

    @Test func setRevealedFalseTakesTheDisplayBackOut() {
        var state = BarPanelVisibilityState()
        state.setHidden([1])
        state.setRevealed(true, for: 1)
        state.setRevealed(false, for: 1)

        #expect(state.revealed.isEmpty)
        #expect(!state.wantsShown(1))
    }

    @Test func aDisplayNeverRecordedIsSettledNeitherWay() {
        let state = BarPanelVisibilityState()

        #expect(!state.isSettled(showing: true, for: 1))
        #expect(!state.isSettled(showing: false, for: 1))
    }

    @Test func recordingMakesTheDisplaySettledOnThatValueAlone() {
        var state = BarPanelVisibilityState()
        state.record(showing: true, for: 1)

        #expect(state.isSettled(showing: true, for: 1))
        #expect(!state.isSettled(showing: false, for: 1))
    }

    @Test func monitoredKeepsADisplayThatIsConcealedButNoLongerHidden() {
        var state = BarPanelVisibilityState()
        state.setHidden([1])
        state.record(showing: false, for: 1)
        state.setHidden([])

        #expect(state.monitored(among: [1]) == [1])
    }

    @Test func monitoredDropsADisplayThatIsShowingAndNotHidden() {
        var state = BarPanelVisibilityState()
        state.record(showing: true, for: 1)

        #expect(state.monitored(among: [1]).isEmpty)
    }

    @Test func monitoredTakesTheHiddenAndTheConcealedTogetherAndOnlyAmongTheGivenIds() {
        var state = BarPanelVisibilityState()
        state.setHidden([1])
        state.record(showing: true, for: 1)
        state.record(showing: false, for: 2)
        state.record(showing: true, for: 3)
        state.record(showing: false, for: 4)

        #expect(state.monitored(among: [1, 2, 3]) == [1, 2])
    }

    @Test func forgetRemovesTheDisplayFromAllThree() {
        var state = BarPanelVisibilityState()
        state.setHidden([1, 2])
        state.setRevealed(true, for: 1)
        state.record(showing: false, for: 1)
        state.forget(1)

        #expect(state.hidden == [2])
        #expect(state.revealed.isEmpty)
        #expect(state.shown.isEmpty)
        #expect(!state.isSettled(showing: false, for: 1))
    }

    @Test func resetEmptiesAllThree() {
        var state = BarPanelVisibilityState()
        state.setHidden([1, 2])
        state.setRevealed(true, for: 1)
        state.record(showing: true, for: 2)
        state.reset()

        #expect(state == BarPanelVisibilityState())
        #expect(state.hidden.isEmpty)
        #expect(state.revealed.isEmpty)
        #expect(state.shown.isEmpty)
    }
}
