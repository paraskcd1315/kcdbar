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

/** The scene a peek draws on each display it covers. */
package enum WindowPeekPolicy {
    package static func scenes(
        for target: WindowPeekTarget,
        windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> [WindowPeekScene] {
        let desktops = displays.filter {
            !FullScreenDisplayPolicy.isFullScreen(onDisplay: $0.id, windows: windows, displays: displays)
        }
        let peeked: ManagedWindow?

        switch target {
        case .desktop:
            peeked = nil
        case .window(let windowId):
            guard let window = windows.first(where: { $0.identity.cgWindowId == windowId }),
                  isPeekable(window),
                  let displayId = WindowDisplayResolver.displayId(for: window, in: displays),
                  desktops.contains(where: { $0.id == displayId })
            else {
                return []
            }
            peeked = window
        }

        let confirmed = WindowPresentationPolicy.taskbarEntries(from: windows)

        return desktops.map { display in
            WindowPeekScene(
                displayId: display.id,
                peeked: peeked.flatMap { window in
                    WindowDisplayResolver.displayId(for: window, in: displays) == display.id ? window.bounds : nil
                },
                outlines: outlines(onDisplay: display.id, excluding: peeked, among: confirmed, displays: displays)
            )
        }
    }

    private static func outlines(
        onDisplay displayId: Int,
        excluding peeked: ManagedWindow?,
        among windows: [ManagedWindow],
        displays: [DisplayGeometry]
    ) -> [CGRect] {
        windows
            .filter { window in
                isPeekable(window)
                    && window.identity != peeked?.identity
                    && WindowDisplayResolver.displayId(for: window, in: displays) == displayId
            }
            .sorted { ($0.zOrder ?? Int.max) > ($1.zOrder ?? Int.max) }
            .compactMap(\.bounds)
    }

    private static func isPeekable(_ window: ManagedWindow) -> Bool {
        !window.isMinimized && !window.isFullScreen && WindowSpacePolicy.isOnActiveSpace(window)
    }
}
