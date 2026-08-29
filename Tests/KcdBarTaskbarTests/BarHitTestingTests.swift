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

struct BarHitTestingTests {
    private let panel = CGRect(x: 0, y: 0, width: 1920, height: 96)
    private let island = CGRect(x: 765, y: 44, width: 390, height: 52)

    @Test func theIslandIsFlippedIntoScreenCoordinates() {
        let screen = BarHitTesting.screenRect(ofView: island, inPanel: panel)

        #expect(screen == CGRect(x: 765, y: 0, width: 390, height: 52))
    }

    @Test func aPanelAwayFromTheOriginCarriesItsOffset() {
        let offset = CGRect(x: 1920, y: -180, width: 1920, height: 96)
        let screen = BarHitTesting.screenRect(ofView: island, inPanel: offset)

        #expect(screen == CGRect(x: 2685, y: -180, width: 390, height: 52))
    }

    @Test func aPointOnTheIslandDoesNotPassThrough() {
        #expect(!BarHitTesting.passesThrough(CGPoint(x: 900, y: 20), barRect: island, panelFrame: panel))
    }

    @Test func theMarginsPassThrough() {
        #expect(BarHitTesting.passesThrough(CGPoint(x: 120, y: 20), barRect: island, panelFrame: panel))
        #expect(BarHitTesting.passesThrough(CGPoint(x: 1800, y: 20), barRect: island, panelFrame: panel))
    }

    @Test func aPointOnTheTooltipAboveTheIslandDoesNotPassThrough() {
        let tooltip = CGRect(x: 800, y: 0, width: 300, height: 40)

        #expect(
            !BarHitTesting.passesThrough(
                CGPoint(x: 900, y: 70), barRect: island, tooltipRect: tooltip, panelFrame: panel))
        #expect(
            BarHitTesting.passesThrough(
                CGPoint(x: 120, y: 70), barRect: island, tooltipRect: tooltip, panelFrame: panel))
    }

    @Test func aPointAboveTheIslandPassesThroughWhenNoTooltipShows() {
        #expect(
            BarHitTesting.passesThrough(
                CGPoint(x: 900, y: 70), barRect: island, tooltipRect: nil, panelFrame: panel))
    }

    @Test func anUnmeasuredBarKeepsItsClicks() {
        #expect(!BarHitTesting.passesThrough(CGPoint(x: 120, y: 20), barRect: nil, panelFrame: panel))
    }
}
