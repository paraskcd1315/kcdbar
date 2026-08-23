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
