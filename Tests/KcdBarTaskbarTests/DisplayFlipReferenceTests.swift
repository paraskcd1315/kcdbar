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

struct DisplayFlipReferenceTests {
    @Test func thePrimaryDisplaysTopIsTheReference() {
        let displays = [
            DisplayGeometry(id: 2, frame: CGRect(x: 1920, y: -180, width: 1920, height: 1080), isPrimary: false),
            DisplayGeometry(id: 1, frame: CGRect(x: 0, y: 0, width: 1440, height: 900), isPrimary: true),
        ]

        #expect(DisplayFlipReference.of(displays) == 900)
    }

    @Test func noDisplaysFlipAgainstZero() {
        #expect(DisplayFlipReference.of([]) == 0)
    }
}
