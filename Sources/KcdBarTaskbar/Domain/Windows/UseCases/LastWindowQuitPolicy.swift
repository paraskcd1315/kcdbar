import Foundation

/** The verdict on an application whose last window closed. */
package enum LastWindowQuitPolicy {
    package static func windowCounts(of windows: [ManagedWindow]) -> [pid_t: Int] {
        windows.reduce(into: [:]) { counts, window in
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
}
