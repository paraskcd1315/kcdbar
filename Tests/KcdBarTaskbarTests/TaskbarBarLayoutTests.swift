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

import SwiftUI
import Testing

@testable import KcdBarTaskbar

struct TaskbarBarLayoutTests {
    @Test func aFloatingBarStaysAnchoredToItsOwnEdge() {
        var floating = BarPresetCatalogue.windows11
        floating.attachment = .floating

        #expect(TaskbarBarLayout.crossAxisVertical(preset: floating) == .bottom)
        #expect(TaskbarBarLayout.outsetPadding(attachment: floating.attachment) == TaskbarMetrics.islandOutset)
    }

    @Test func aFloatingTopBarAnchorsToTheTop() {
        var floating = BarPresetCatalogue.minimal
        floating.edge = .top
        floating.attachment = .floating

        #expect(TaskbarBarLayout.crossAxisVertical(preset: floating) == .top)
    }

    @Test func aFloatingVerticalBarAnchorsToItsSide() {
        var floating = BarPresetCatalogue.windows11
        floating.edge = .leading
        floating.attachment = .floating

        #expect(TaskbarBarLayout.crossAxisHorizontal(preset: floating) == .leading)

        floating.edge = .trailing

        #expect(TaskbarBarLayout.crossAxisHorizontal(preset: floating) == .trailing)
    }

    @Test func theFloatingFrameIsTheBarPlusItsOutsetOnBothSides() {
        var floating = BarPresetCatalogue.windows11
        floating.attachment = .floating
        let display = DisplayGeometry(
            id: 1,
            frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
            isPrimary: true
        )

        let frame = BarFrameCalculator.frame(for: floating, on: display)

        #expect(frame.height == floating.thickness + TaskbarMetrics.islandOutset * 2)
        #expect(frame.minY == 0)
    }
}
