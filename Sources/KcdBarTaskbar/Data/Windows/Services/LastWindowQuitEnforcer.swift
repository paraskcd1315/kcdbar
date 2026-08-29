import CoreGraphics
import Foundation

/** Quits an application whose last window closed since the previous refresh. */
@MainActor
package final class LastWindowQuitEnforcer {
    private let terminator: any ApplicationTerminationPort
    private let menuExtras: any MenuExtraOwnershipPort
    private let isEnabled: () -> Bool
    private let excluded: () -> Set<String>
    private var previous: [pid_t: Int] = [:]
    private var confirmed: Set<CGWindowID> = []

    package init(
        terminator: any ApplicationTerminationPort,
        menuExtras: any MenuExtraOwnershipPort,
        isEnabled: @escaping () -> Bool,
        excluded: @escaping () -> Set<String>
    ) {
        self.terminator = terminator
        self.menuExtras = menuExtras
        self.isEnabled = isEnabled
        self.excluded = excluded
    }

    @discardableResult
    package func enforce(
        windows: [ManagedWindow],
        applications: [RunningApplication],
        now: Date = Date()
    ) -> [LastWindowQuitDecision] {
        confirmed = LastWindowQuitPolicy.confirmed(among: windows, previously: confirmed)
        let current = LastWindowQuitPolicy.windowCounts(of: windows, confirmed: confirmed)
        defer { previous = current }
        guard isEnabled() else { return [] }

        let closed = LastWindowQuitPolicy.closedOut(previous: previous, current: current, among: applications)
        let exclusions = excluded()

        return closed.map { application in
            let verdict = LastWindowQuitPolicy.decide(application, excluded: exclusions, now: now) {
                menuExtras.hasMenuExtra(pid: application.pid)
            }
            if verdict == .quit, let bundleIdentifier = application.bundleIdentifier {
                _ = terminator.quit(bundleIdentifier: bundleIdentifier)
            }
            return LastWindowQuitDecision(application: application, verdict: verdict)
        }
    }
}
