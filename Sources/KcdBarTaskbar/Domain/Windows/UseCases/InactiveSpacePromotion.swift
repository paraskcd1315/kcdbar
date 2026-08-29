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

/** A CoreGraphics-only window on a Space that is not its display's current one is a real window nobody can list. */
package enum InactiveSpacePromotion {
    package static func candidates(among windows: [ManagedWindow]) -> [CGWindowID] {
        windows
            .filter { $0.source == .coreGraphicsOnly && isWindowSized($0.bounds) }
            .compactMap(\.identity.cgWindowId)
    }

    package static func isWindowSized(_ bounds: CGRect?) -> Bool {
        guard let bounds else { return false }

        return bounds.width >= InactiveSpaceMetrics.minimumSide
            && bounds.height >= InactiveSpaceMetrics.minimumSide
    }

    package static func promote(
        _ windows: [ManagedWindow],
        onInactiveSpaces promoted: Set<CGWindowID>,
        displays: [DisplayGeometry]
    ) -> [ManagedWindow] {
        guard !promoted.isEmpty else { return windows }

        return windows.map { window in
            guard window.source == .coreGraphicsOnly,
                  let id = window.identity.cgWindowId, promoted.contains(id)
            else {
                return window
            }
            return ManagedWindow(
                identity: window.identity,
                ownerPid: window.ownerPid,
                ownerName: window.ownerName,
                title: window.title,
                bounds: window.bounds,
                isMinimized: false,
                isFullScreen: fillsADisplay(window.bounds, displays: displays),
                isOnScreen: window.isOnScreen,
                zOrder: window.zOrder,
                source: .inactiveSpace,
                accessibilityTitle: window.accessibilityTitle
            )
        }
    }

    private static func fillsADisplay(_ bounds: CGRect?, displays: [DisplayGeometry]) -> Bool {
        guard let bounds else { return false }

        return displays.contains { $0.frame.size == bounds.size }
    }
}
