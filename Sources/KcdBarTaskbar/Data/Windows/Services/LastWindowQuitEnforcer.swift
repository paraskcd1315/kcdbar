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
        let current = LastWindowQuitPolicy.windowCounts(of: windows)
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
