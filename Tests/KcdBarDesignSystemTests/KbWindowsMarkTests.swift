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
import SwiftUI
import Testing

@testable import KcdBarDesignSystem

struct KbWindowsMarkTests {
    private let frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    @Test func theElevenMarkDrawsFourPanesInsideItsFrame() {
        let path = KbWindows11Shape().path(in: frame)
        var corners = 0
        path.forEach { element in
            if case .move = element { corners += 1 }
        }

        #expect(corners == 4)
        #expect(frame.insetBy(dx: -1, dy: -1).contains(path.boundingRect))
    }

    @Test func theTenMarkDrawsFourPanesInsideItsFrame() {
        let path = KbWindows10Shape().path(in: frame)
        var corners = 0
        path.forEach { element in
            if case .move = element { corners += 1 }
        }

        #expect(corners == 4)
        #expect(frame.insetBy(dx: -1, dy: -1).contains(path.boundingRect))
    }

    @Test func theTenMarksLeftEdgeIsShorterThanItsRight() {
        let path = KbWindows10Shape().path(in: frame)
        var leftTop = CGFloat.greatestFiniteMagnitude
        var rightTop = CGFloat.greatestFiniteMagnitude

        path.forEach { element in
            guard case .line(let point) = element else { return }

            if point.x <= frame.minX + 1 {
                leftTop = min(leftTop, point.y)
            }
            if point.x >= frame.maxX - 1 {
                rightTop = min(rightTop, point.y)
            }
        }

        #expect(rightTop < leftTop)
    }
}
