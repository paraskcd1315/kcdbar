import Foundation
import Testing

@testable import KcdBarTaskbar

@MainActor
struct DockSuppressionStateTests {
    private let now = Date(timeIntervalSinceReferenceDate: 800_000_000)

    private var theirs: DockSettingsSnapshot {
        DockSettingsSnapshot(
            autohide: false,
            autohideDelay: 0.5,
            autohideTimeModifier: 1,
            minimizeEffect: "genie"
        )
    }

    private func state(
        store: RememberingDockSnapshotStore
    ) -> (DockSuppressionState, RecordingDockControl) {
        let control = RecordingDockControl(held: theirs)

        return (DockSuppressionState(control: control, store: store), control)
    }

    @Test func hidingRemembersWhatTheDockHeldBeforeItWroteAnything() async {
        let store = RememberingDockSnapshotStore()
        let (dock, control) = state(store: store)

        await dock.apply(handling: .hide, now: now)

        #expect(await store.snapshot() == theirs)
        #expect(control.written.count == 1)
        #expect(control.restarts == 1)
    }

    @Test func hidingTwiceRestartsTheDockOnce() async {
        let store = RememberingDockSnapshotStore()
        let (dock, control) = state(store: store)

        await dock.apply(handling: .hide, now: now)
        await dock.apply(handling: .hide, now: now.addingTimeInterval(600))

        #expect(control.restarts == 1)
        #expect(dock.verdict == .unchanged)
    }

    @Test func anUnrelatedPresetChangeNeverTouchesTheDockAgain() async {
        let store = RememberingDockSnapshotStore()
        let (dock, control) = state(store: store)

        await dock.apply(handling: .hide, now: now)
        for tick in 1...20 {
            await dock.apply(handling: .hide, now: now.addingTimeInterval(Double(tick) * 60))
        }

        #expect(control.restarts == 1)
        #expect(control.written.count == 1)
    }

    @Test func turningTheAxisOffGivesTheDockBackAndForgetsTheSnapshot() async {
        let store = RememberingDockSnapshotStore()
        let (dock, control) = state(store: store)

        await dock.apply(handling: .hide, now: now)
        await dock.apply(handling: .leaveAlone, now: now.addingTimeInterval(600))

        #expect(dock.verdict == .restored)
        #expect(control.restarts == 2)
        #expect(await store.snapshot() == nil)
        #expect(dock.isChanged == false)
    }

    @Test func restoringWhenNothingWasChangedRestartsNothing() async {
        let store = RememberingDockSnapshotStore()
        let (dock, control) = state(store: store)

        await dock.restore(now: now)

        #expect(dock.verdict == .leftAlone)
        #expect(control.restarts == 0)
        #expect(control.written.isEmpty)
        #expect(await store.clears == 0)
    }

    @Test func aSnapshotLeftByACrashedRunIsAppliedAtTheNextLaunch() async {
        let store = RememberingDockSnapshotStore(held: theirs)
        let (dock, control) = state(store: store)

        await dock.load()
        await dock.apply(handling: .leaveAlone, now: now)

        #expect(dock.verdict == .restored)
        #expect(control.restarts == 1)
        #expect(control.written.first?.map(\.value) == [
            .flag(false), .number(0.5), .number(1), .text("genie"),
        ])
        #expect(await store.snapshot() == nil)
    }

    @Test func aSnapshotLeftBehindWhileTheAxisStillHidesIsLeftWhereItIs() async {
        let store = RememberingDockSnapshotStore(held: theirs)
        let (dock, control) = state(store: store)

        await dock.load()
        await dock.apply(handling: .hide, now: now)

        #expect(dock.verdict == .unchanged)
        #expect(control.restarts == 0)
        #expect(await store.snapshot() == theirs)
    }

    @Test func aChangeInsideTheFloorWritesNothingAndKeepsTheOlderState() async {
        let store = RememberingDockSnapshotStore()
        let (dock, control) = state(store: store)

        await dock.apply(handling: .hide, now: now)
        await dock.apply(handling: .leaveAlone, now: now.addingTimeInterval(1))

        #expect(dock.verdict == .tooSoon)
        #expect(control.restarts == 1)
        #expect(dock.isChanged)
        #expect(await store.snapshot() == theirs)
    }
}
