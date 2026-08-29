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

package enum BarHitTesting {
    package static func screenRect(ofView viewRect: CGRect, inPanel panelFrame: CGRect) -> CGRect {
        CGRect(
            x: panelFrame.minX + viewRect.minX,
            y: panelFrame.maxY - viewRect.maxY,
            width: viewRect.width,
            height: viewRect.height
        )
    }

    package static func passesThrough(
        _ point: CGPoint,
        barRect: CGRect?,
        tooltipRect: CGRect? = nil,
        panelFrame: CGRect
    ) -> Bool {
        guard let barRect else { return false }
        if screenRect(ofView: barRect, inPanel: panelFrame).contains(point) { return false }
        if let tooltipRect, screenRect(ofView: tooltipRect, inPanel: panelFrame).contains(point) {
            return false
        }

        return true
    }
}
