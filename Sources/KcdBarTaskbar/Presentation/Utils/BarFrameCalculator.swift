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

package enum BarFrameCalculator {
    package static func panelFrame(for preset: BarPreset, on display: DisplayGeometry) -> CGRect {
        let bar = frame(for: preset, on: display)
        let allowance = TaskbarPreviewMetrics.panelAllowance

        switch preset.edge {
        case .bottom:
            return CGRect(x: bar.minX, y: bar.minY, width: bar.width, height: bar.height + allowance)
        case .top:
            return CGRect(
                x: bar.minX,
                y: bar.minY - allowance,
                width: bar.width,
                height: bar.height + allowance
            )
        case .leading:
            return CGRect(x: bar.minX, y: bar.minY, width: bar.width + allowance, height: bar.height)
        case .trailing:
            return CGRect(
                x: bar.minX - allowance,
                y: bar.minY,
                width: bar.width + allowance,
                height: bar.height
            )
        }
    }

    package static func itemAnchor(
        for preset: BarPreset,
        on display: DisplayGeometry,
        at pointer: CGPoint
    ) -> CGRect {
        let bar = frame(for: preset, on: display)
        let side = BarEntryMetrics.itemSide(for: preset)

        switch preset.edge {
        case .bottom, .top:
            return CGRect(x: pointer.x - side / 2, y: bar.minY, width: side, height: bar.height)
        case .leading, .trailing:
            return CGRect(x: bar.minX, y: pointer.y - side / 2, width: bar.width, height: side)
        }
    }

    package static func frame(for preset: BarPreset, on display: DisplayGeometry) -> CGRect {
        let screen = display.frame
        let thickness = preset.thickness + (preset.attachment == .floating ? TaskbarMetrics.islandOutset * 2 : 0)
        switch preset.edge {
        case .bottom:
            return CGRect(x: screen.minX, y: screen.minY, width: screen.width, height: thickness)
        case .top:
            return CGRect(x: screen.minX, y: screen.maxY - thickness, width: screen.width, height: thickness)
        case .leading:
            return CGRect(x: screen.minX, y: screen.minY, width: thickness, height: screen.height)
        case .trailing:
            return CGRect(x: screen.maxX - thickness, y: screen.minY, width: thickness, height: screen.height)
        }
    }
}
