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
@testable import KcdBarTray

struct PopoverAnchorTests {
    private let screen = CGRect(x: 0, y: 0, width: 1920, height: 1080)
    private let size = CGSize(width: 340, height: 200)

    @Test func aPopoverCentresOnItsAnchor() {
        let origin = PopoverAnchor.origin(for: size, anchor: CGPoint(x: 960, y: 40), within: screen)

        #expect(origin.x == 790)
    }

    @Test func aPopoverNearTheLeftEdgeStopsAtIt() {
        let origin = PopoverAnchor.origin(for: size, anchor: CGPoint(x: 20, y: 40), within: screen)

        #expect(origin.x == 0)
    }

    @Test func aPopoverNearTheRightEdgeStopsAtIt() {
        let origin = PopoverAnchor.origin(for: size, anchor: CGPoint(x: 1900, y: 40), within: screen)

        #expect(origin.x == 1580)
    }

    @Test func aPopoverSitsAboveItsAnchor() {
        let origin = PopoverAnchor.origin(for: size, anchor: CGPoint(x: 960, y: 40), within: screen)

        #expect(origin.y > 40)
    }

    @Test func aTallPopoverIsHeldInsideTheTopEdge() {
        let tall = CGSize(width: 340, height: 1200)
        let origin = PopoverAnchor.origin(for: tall, anchor: CGPoint(x: 960, y: 40), within: screen)

        #expect(origin.y == 0)
    }

    @Test func aPopoverThatFitsKeepsTheSizeItAskedFor() {
        let fitted = PopoverAnchor.fittedSize(size, anchor: CGPoint(x: 960, y: 52), within: screen)

        #expect(fitted == size)
    }

    @Test func aTallPopoverIsCutToTheRoomAboveItsAnchor() {
        let tall = CGSize(width: 340, height: 1200)
        let fitted = PopoverAnchor.fittedSize(tall, anchor: CGPoint(x: 960, y: 52), within: screen)

        #expect(fitted.height == 1022)
        #expect(fitted.width == 340)
    }

    @Test func anAnchorAtTheTopEdgeLeavesNoNegativeHeight() {
        let fitted = PopoverAnchor.fittedSize(size, anchor: CGPoint(x: 960, y: 1080), within: screen)

        #expect(fitted.height == 0)
    }
}
