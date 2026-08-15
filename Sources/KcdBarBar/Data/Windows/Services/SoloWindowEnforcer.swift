import Foundation

/** Keeps one window per display, and hands the last one back when it is left alone. */
@MainActor
package final class SoloWindowEnforcer {
    private let control: any WindowControlPort
    private var memory = SoloWindowMemory()
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
        memory.drop(identitiesNotIn: Set(windows.map(\.identity)))

        if let lastEnforced, now.timeIntervalSince(lastEnforced) < SoloWindowMetrics.interval {
            return
        }
        lastEnforced = now

        let crowd = SoloWindowPolicy.toMinimise(
            frontmostPid: frontmostPid,
            among: windows,
            displays: displays
        )
        guard crowd.isEmpty else {
            minimise(crowd, displays: displays)
            return
        }
        restoreIfDisplayIsBare(windows: windows, displays: displays)
    }

    private func minimise(_ crowd: [ManagedWindow], displays: [DisplayGeometry]) {
        for window in crowd {
            guard let display = WindowDisplayResolver.displayId(for: window, in: displays) else {
                continue
            }
            memory.remember([window], onDisplay: display)
            _ = control.perform(.minimize, on: window)
        }
    }

    private func restoreIfDisplayIsBare(windows: [ManagedWindow], displays: [DisplayGeometry]) {
        for display in displays where SoloWindowPolicy.isBare(
            display: display.id,
            among: windows,
            displays: displays
        ) {
            guard let identity = memory.takeMostRecent(onDisplay: display.id),
                  let window = windows.first(where: { $0.identity == identity })
            else {
                continue
            }
            _ = control.perform(.restore, on: window)
        }
    }
}
