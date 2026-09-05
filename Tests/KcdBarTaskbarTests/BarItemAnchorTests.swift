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

struct BarItemAnchorTests {
    private let display = DisplayGeometry(
        id: 1,
        frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
        isPrimary: true
    )

    @Test func theAnchorIsCentredOnThePointerAndSpansTheBar() {
        let preset = BarPresetCatalogue.windows11

        let bar = BarFrameCalculator.frame(for: preset, on: display)
        let anchor = BarFrameCalculator.itemAnchor(
            for: preset, on: display, at: CGPoint(x: 1200, y: 12))

        #expect(anchor.midX == 1200)
        #expect(anchor.minY == bar.minY)
        #expect(anchor.maxY == bar.maxY)
        #expect(anchor.width == BarEntryMetrics.itemSide(for: preset))
    }

    @Test func theAnchorIsDrawableSoTheConsoleAcceptsIt() {
        let anchor = BarFrameCalculator.itemAnchor(
            for: BarPresetCatalogue.windows11, on: display, at: CGPoint(x: 1200, y: 12))

        #expect(anchor.width > 0)
        #expect(anchor.height > 0)
    }

    @Test func aVerticalBarAnchorsAlongItsOwnAxis() {
        var preset = BarPresetCatalogue.windows11
        preset.edge = .leading

        let bar = BarFrameCalculator.frame(for: preset, on: display)
        let anchor = BarFrameCalculator.itemAnchor(
            for: preset, on: display, at: CGPoint(x: 12, y: 700))

        #expect(anchor.midY == 700)
        #expect(anchor.minX == bar.minX)
        #expect(anchor.width == bar.width)
        #expect(anchor.height == BarEntryMetrics.itemSide(for: preset))
    }
}
