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

/** Whether the frontmost window on a display is fullscreen. */
package enum FullScreenDisplayPolicy {
    package static func isFullScreen(
        onDisplay displayId: Int,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> Bool {
        let confirmed = WindowPresentationPolicy.taskbarEntries(from: windows)

        return frontmost(onDisplay: displayId, windows: confirmed, displays: displays)?.isFullScreen == true
    }

    private static func frontmost(
        onDisplay displayId: Int,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> ManagedWindow? {
        windows
            .filter { window in
                guard !window.isMinimized, WindowSpacePolicy.isOnActiveSpace(window) else {
                    return false
                }

                return WindowDisplayResolver.displayId(for: window, in: displays) == displayId
            }
            .min { ($0.zOrder ?? Int.max) < ($1.zOrder ?? Int.max) }
    }
}
