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

import Foundation

/** Keeps one window per display, acting only when the user moves focus, and hands the last one back. */
@MainActor
package final class SoloWindowEnforcer {
    private let control: any WindowControlPort
    private let isEnabled: () -> Bool
    private var memory = SoloWindowMemory()
    private var firstSeen: [WindowIdentity: Date] = [:]
    private var lastFocus: WindowIdentity?

    package init(
        control: any WindowControlPort,
        isEnabled: @escaping () -> Bool = { SoloWindowPreference.isEnabled }
    ) {
        self.control = control
        self.isEnabled = isEnabled
    }

    package func enforce(
        frontmostPid: pid_t?,
        windows: [ManagedWindow],
        displays: [DisplayGeometry],
        now: Date = Date()
    ) {
        guard isEnabled() else { return }

        let alive = Set(windows.map(\.identity))
        note(windows, at: now)
        memory.drop(identitiesNotIn: alive)

        guard let focus = SoloWindowPolicy.focused(frontmostPid: frontmostPid, among: windows),
              focus.identity != lastFocus
        else {
            return
        }
        lastFocus = focus.identity

        let crowd = SoloWindowPolicy.toMinimise(
            frontmostPid: frontmostPid,
            among: windows,
            displays: displays
        )
        .filter { settled($0, at: now) }

        guard crowd.isEmpty else {
            minimise(crowd, displays: displays)
            return
        }
        restoreIfDisplayIsBare(windows: windows, displays: displays)
    }

    private func note(_ windows: [ManagedWindow], at now: Date) {
        let alive = Set(windows.map(\.identity))
        firstSeen = firstSeen.filter { alive.contains($0.key) }
        for window in windows where firstSeen[window.identity] == nil {
            firstSeen[window.identity] = now
        }
    }

    private func settled(_ window: ManagedWindow, at now: Date) -> Bool {
        guard let seen = firstSeen[window.identity] else { return false }

        return now.timeIntervalSince(seen) >= SoloWindowMetrics.grace
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
