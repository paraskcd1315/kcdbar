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

@testable import KcdBarDesignSystem

struct ColorHexTests {
    @Test func aSixDigitHexBecomesAColour() {
        #expect(Color(hex: "#0B83D9") != nil)
    }

    @Test func theLeadingHashIsOptional() {
        #expect(Color(hex: "0B83D9") == Color(hex: "#0B83D9"))
    }

    @Test func theCaseOfTheDigitsDoesNotMatter() {
        #expect(Color(hex: "#0b83d9") == Color(hex: "#0B83D9"))
    }

    @Test func aTrackerStatingNoColourGetsNoneRatherThanBlack() {
        #expect(Color(hex: "") == nil)
    }

    @Test func aShorthandHexIsRefusedRatherThanGuessedAt() {
        #expect(Color(hex: "#0BD") == nil)
    }

    @Test func anEightDigitHexIsRefused() {
        #expect(Color(hex: "#FF0B83D9") == nil)
    }

    @Test func somethingThatIsNotHexAtAllIsRefused() {
        #expect(Color(hex: "#ZZZZZZ") == nil)
    }
}
