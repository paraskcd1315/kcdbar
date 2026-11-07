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

/** The displays a peek covers. */
package enum WindowPeekPolicy {
    package static func displayIds(
        for target: WindowPeekTarget,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> [Int] {
        let desktops = displays
            .map(\.id)
            .filter { !FullScreenDisplayPolicy.isFullScreen(onDisplay: $0, windows: windows, displays: displays) }

        switch target {
        case .desktop:
            return desktops
        case .window(let windowId):
            guard let window = windows.first(where: { $0.identity.cgWindowId == windowId }),
                  isPeekable(window),
                  let displayId = WindowDisplayResolver.displayId(for: window, in: displays),
                  desktops.contains(displayId)
            else {
                return []
            }

            return desktops
        }
    }

    private static func isPeekable(_ window: ManagedWindow) -> Bool {
        !window.isMinimized && !window.isFullScreen && WindowSpacePolicy.isOnActiveSpace(window)
    }
}
