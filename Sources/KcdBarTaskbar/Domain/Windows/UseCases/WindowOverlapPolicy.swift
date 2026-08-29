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

package enum WindowOverlapPolicy {
    package static func correctedFrame(
        for window: ManagedWindow,
        barFrame: CGRect,
        display: DisplayGeometry
    ) -> CGRect? {
        guard let bounds = window.bounds, !window.isMinimized, !window.isFullScreen else { return nil }
        guard bounds.intersects(barFrame) else { return nil }

        let available = usableArea(of: display, excluding: barFrame)
        let corrected = fillsDisplay(bounds, display: display)
            ? bounds.intersection(available)
            : fitted(bounds, into: available)
        guard !corrected.isNull, corrected.height > 0, corrected.width > 0 else { return nil }
        guard !isSame(corrected, bounds) else { return nil }
        return corrected
    }

    package static func fitted(_ bounds: CGRect, into available: CGRect) -> CGRect {
        var moved = bounds

        if moved.minX < available.minX { moved.origin.x = available.minX }
        if moved.maxX > available.maxX { moved.origin.x = available.maxX - moved.width }
        if moved.minY < available.minY { moved.origin.y = available.minY }
        if moved.maxY > available.maxY { moved.origin.y = available.maxY - moved.height }

        guard moved.width <= available.width, moved.height <= available.height else {
            return moved.intersection(available)
        }
        return moved
    }

    package static func usableArea(of display: DisplayGeometry, excluding barFrame: CGRect) -> CGRect {
        let screen = display.frame
        guard screen.intersects(barFrame) else { return screen }

        let tolerance = WindowMatchingMetrics.boundsTolerance

        if barFrame.width >= screen.width - tolerance {
            if barFrame.minY <= screen.minY + tolerance {
                return CGRect(
                    x: screen.minX,
                    y: barFrame.maxY,
                    width: screen.width,
                    height: screen.maxY - barFrame.maxY
                )
            }
            return CGRect(x: screen.minX, y: screen.minY, width: screen.width, height: barFrame.minY - screen.minY)
        }

        if barFrame.minX <= screen.minX + tolerance {
            return CGRect(
                x: barFrame.maxX,
                y: screen.minY,
                width: screen.maxX - barFrame.maxX,
                height: screen.height
            )
        }
        return CGRect(x: screen.minX, y: screen.minY, width: barFrame.minX - screen.minX, height: screen.height)
    }

    private static func fillsDisplay(_ bounds: CGRect, display: DisplayGeometry) -> Bool {
        let screen = display.frame
        let coverage = bounds.intersection(screen)
        guard !coverage.isNull else { return false }
        return coverage.width >= screen.width * displayFillRatio
            && coverage.height >= screen.height * displayFillRatio
    }

    private static func isSame(_ lhs: CGRect, _ rhs: CGRect) -> Bool {
        let tolerance = WindowMatchingMetrics.boundsTolerance
        return abs(lhs.minX - rhs.minX) <= tolerance
            && abs(lhs.minY - rhs.minY) <= tolerance
            && abs(lhs.width - rhs.width) <= tolerance
            && abs(lhs.height - rhs.height) <= tolerance
    }

    private static let displayFillRatio: CGFloat = 0.92
}
