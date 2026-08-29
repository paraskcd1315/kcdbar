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

/** The verdict on an application whose last window closed. */
package enum LastWindowQuitPolicy {
    package static func windowCounts(of windows: [ManagedWindow]) -> [pid_t: Int] {
        windows.reduce(into: [:]) { counts, window in
            guard window.source != .coreGraphicsOnly else { return }
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
