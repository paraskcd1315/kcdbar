import Foundation

/** Keeps one window per display by minimizing the rest. */
@MainActor
package final class SoloWindowEnforcer {
    private let control: any WindowControlPort
    private var lastEnforced: Date?

    package init(control: any WindowControlPort) {
        self.control = control
    }

    package func enforce(
        frontmostPid: pid_t?,
        windows: [ManagedWindow],
        displays: [DisplayGeometry],
        now: Date = Date()
    ) {
        if let lastEnforced, now.timeIntervalSince(lastEnforced) < SoloWindowMetrics.interval {
            return
        }
        let crowd = SoloWindowPolicy.toMinimise(
            frontmostPid: frontmostPid,
            among: windows,
            displays: displays
        )
        guard !crowd.isEmpty else { return }

        lastEnforced = now
        for window in crowd {
            _ = control.perform(.minimize, on: window)
        }
    }
}
