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

/** One window per display: everything else sharing that display is minimized. */
package enum SoloWindowPolicy {
    package static func toMinimise(
        frontmostPid: pid_t?,
        among windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> [ManagedWindow] {
        guard let focused = focused(frontmostPid: frontmostPid, among: windows),
              let display = WindowDisplayResolver.displayId(for: focused, in: displays)
        else {
            return []
        }

        return windows.filter { window in
            guard window.identity != focused.identity else { return false }
            guard window.ownerPid != focused.ownerPid else { return false }
            guard !window.isMinimized, !window.isFullScreen else { return false }
            guard WindowSpacePolicy.isOnActiveSpace(window) else { return false }

            return WindowDisplayResolver.displayId(for: window, in: displays) == display
        }
    }

    package static func isBare(
        display: Int,
        among windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> Bool {
        !windows.contains { window in
            guard !window.isMinimized else { return false }

            return WindowDisplayResolver.displayId(for: window, in: displays) == display
        }
    }

    package static func focused(
        frontmostPid: pid_t?,
        among windows: [ManagedWindow]
    ) -> ManagedWindow? {
        windows.first {
            WindowFocusPolicy.isFrontmost($0, frontmostPid: frontmostPid, among: windows)
        }
    }
}
