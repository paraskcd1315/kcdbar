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

struct PopoverSizingTests {
    @Test func anIdenticalMeasurementDoesNotResizeTheWindow() {
        let size = CGSize(width: 340, height: 420)

        #expect(PopoverSizing.isSettled(size, against: size))
    }

    @Test func aSubPointDifferenceDoesNotResizeTheWindow() {
        #expect(
            PopoverSizing.isSettled(
                CGSize(width: 340.4, height: 420.2),
                against: CGSize(width: 340, height: 420)
            )
        )
    }

    @Test func aRealGrowthResizesTheWindow() {
        #expect(
            !PopoverSizing.isSettled(
                CGSize(width: 340, height: 520),
                against: CGSize(width: 340, height: 420)
            )
        )
    }

    @Test func aFirstMeasurementAlwaysResizes() {
        #expect(!PopoverSizing.isSettled(CGSize(width: 340, height: 420), against: .zero))
    }
}
