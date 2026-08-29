import CoreGraphics
import Foundation

/** The verdict on an application whose last window closed. */
package enum LastWindowQuitPolicy {
    package static func confirmed(
        among windows: [ManagedWindow],
        previously: Set<CGWindowID>
    ) -> Set<CGWindowID> {
        let reported = Set(windows.compactMap(\.identity.cgWindowId))
        let confirmedNow = windows
            .filter { $0.source != .coreGraphicsOnly }
            .compactMap(\.identity.cgWindowId)
        return previously.intersection(reported).union(confirmedNow)
    }

    package static func windowCounts(
        of windows: [ManagedWindow],
        confirmed: Set<CGWindowID>
    ) -> [pid_t: Int] {
        windows.reduce(into: [:]) { counts, window in
            guard isCounted(window, confirmed: confirmed) else { return }
            counts[window.ownerPid, default: 0] += 1
        }
    }

    package static func closedOut(
        previous: [pid_t: Int],
        current: [pid_t: Int],
        among applications: [RunningApplication]
    ) -> [RunningApplication] {
        applications.filter { application in
            previous[application.pid, default: 0] > 0 && current[application.pid, default: 0] == 0
        }
    }

    package static func decide(
        _ application: RunningApplication,
        excluded: Set<String>,
        now: Date,
        menuExtra: () -> Bool?
    ) -> LastWindowQuitVerdict {
        guard let bundleIdentifier = application.bundleIdentifier,
              ApplicationQuitPolicy.canQuit(bundleIdentifier: bundleIdentifier)
        else {
            return .unquittable
        }
        if excluded.contains(bundleIdentifier) {
            return .excluded
        }
        if let launchedAt = application.launchedAt,
           now.timeIntervalSince(launchedAt) < LastWindowQuitMetrics.launchGrace
        {
            return .launching
        }
        switch menuExtra() {
        case nil: return .silent
        case true?: return .menuExtra
        case false?: return .quit
        }
    }

    private static func isCounted(_ window: ManagedWindow, confirmed: Set<CGWindowID>) -> Bool {
        if window.source != .coreGraphicsOnly { return true }
        guard let id = window.identity.cgWindowId else { return false }
        return confirmed.contains(id)
    }
}
