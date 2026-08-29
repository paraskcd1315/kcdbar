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

/** Assigns a window to the display it mostly occupies. */
package enum WindowDisplayResolver {
    package static func displayId(for window: ManagedWindow, in displays: [DisplayGeometry]) -> Int? {
        guard let bounds = window.bounds else { return displays.first(where: \.isPrimary)?.id }
        let overlaps = displays
            .map { ($0.id, $0.frame.intersection(bounds)) }
            .filter { !$0.1.isNull && $0.1.width > 0 && $0.1.height > 0 }
        guard let best = overlaps.max(by: { area($0.1) < area($1.1) }) else {
            return nearestDisplayId(to: bounds, in: displays)
        }
        return best.0
    }

    package static func windows(
        _ windows: [ManagedWindow],
        onDisplay displayId: Int,
        scope: BarWindowScope,
        displays: [DisplayGeometry]
    ) -> [ManagedWindow] {
        guard scope == .thisDisplay else { return windows }
        return windows.filter { self.displayId(for: $0, in: displays) == displayId }
    }

    private static func area(_ rect: CGRect) -> CGFloat {
        rect.width * rect.height
    }

    private static func nearestDisplayId(to bounds: CGRect, in displays: [DisplayGeometry]) -> Int? {
        displays
            .min { distance(from: bounds, to: $0.frame) < distance(from: bounds, to: $1.frame) }?
            .id
    }

    private static func distance(from bounds: CGRect, to frame: CGRect) -> CGFloat {
        let dx = bounds.midX - frame.midX
        let dy = bounds.midY - frame.midY
        return dx * dx + dy * dy
    }
}
