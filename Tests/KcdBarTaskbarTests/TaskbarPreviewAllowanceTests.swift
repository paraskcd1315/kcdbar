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
import Testing

@testable import KcdBarTaskbar

struct TaskbarPreviewAllowanceTests {
    private let display = DisplayGeometry(
        id: 1,
        frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
        isPrimary: true
    )

    @Test func thePanelReservesRoomForAThumbnailAboveTheTooltipText() {
        #expect(TaskbarPreviewMetrics.panelAllowance >= TaskbarMetrics.tooltipAllowance + TaskbarPreviewMetrics.thumbnailHeight)
    }

    @Test func aBottomBarGrowsItsPanelUpwardsByTheWholeAllowance() {
        let preset = BarPresetCatalogue.windows11

        let bar = BarFrameCalculator.frame(for: preset, on: display)
        let panel = BarFrameCalculator.panelFrame(for: preset, on: display)

        #expect(panel.height - bar.height == TaskbarPreviewMetrics.panelAllowance)
    }

    @Test func aTopBarGrowsItsPanelDownwardsByTheWholeAllowance() {
        var preset = BarPresetCatalogue.windows11
        preset.edge = .top

        let bar = BarFrameCalculator.frame(for: preset, on: display)
        let panel = BarFrameCalculator.panelFrame(for: preset, on: display)

        #expect(panel.height - bar.height == TaskbarPreviewMetrics.panelAllowance)
        #expect(panel.minY == bar.minY - TaskbarPreviewMetrics.panelAllowance)
    }

    @Test func theCaptureIsAskedForMorePixelsThanTheTileDraws() {
        let tile = CGSize(width: 168, height: 90)
        let capture = TaskbarPreviewMetrics.captureSize(for: tile)

        #expect(capture.width > tile.width)
        #expect(capture.height > tile.height)
        #expect(capture.width / capture.height == tile.width / tile.height)
    }
}
