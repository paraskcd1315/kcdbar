import Foundation
import KcdBarTray
import Observation

/** The one caller of the Dock, keeping the snapshot and the last restart in step with the store. */
@MainActor
@Observable
package final class DockSuppressionState {
    package private(set) var verdict: DockVerdict = .leftAlone

    private let control: any DockControlPort
    private let store: any DockSnapshotStorePort
    private var captured: DockSettingsSnapshot?
    private var lastRestart: Date?

    package init(control: any DockControlPort, store: any DockSnapshotStorePort) {
        self.control = control
        self.store = store
    }

    package var isChanged: Bool {
        captured != nil
    }

    package func load() async {
        captured = await store.snapshot()
    }

    package func apply(handling: DockHandling, now: Date = Date()) async {
        let decision = DockSuppressionPolicy.decide(
            handling: handling,
            captured: captured,
            lastRestart: lastRestart,
            now: now,
            current: { control.settings() }
        )

        await carry(out: decision, at: now)
    }

    package func restore(now: Date = Date()) async {
        let decision = DockSuppressionPolicy.decide(
            handling: .leaveAlone,
            captured: captured,
            lastRestart: nil,
            now: now,
            current: { control.settings() }
        )

        await carry(out: decision, at: now)
    }

    private func carry(out decision: DockDecision, at now: Date) async {
        verdict = decision.verdict
        if let capture = decision.capture {
            captured = capture
            await store.remember(capture)
        }
        control.write(decision.write)
        if decision.restart {
            control.restart()
            lastRestart = now
        }
        if decision.forget {
            captured = nil
            await store.clear()
        }
        BarLog.bar.notice("dock verdict=\(decision.verdict.rawValue, privacy: .public)")
    }
}
