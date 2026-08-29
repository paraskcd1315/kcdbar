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

import Testing

@testable import KcdBarTray

struct TmuxTargetTests {
    @Test func anAddressSplitsIntoTheTwoTargetsSelectingItTakes() {
        let target = TmuxTarget.of("ClaudeContext:@0.%0")

        #expect(target?.window == "ClaudeContext:@0")
        #expect(target?.pane == "%0")
    }

    @Test func aSessionNameCarryingADotSplitsOnTheLastOne() {
        let target = TmuxTarget.of("my.project:@3.%12")

        #expect(target?.window == "my.project:@3")
        #expect(target?.pane == "%12")
    }

    @Test func anAddressWithNoPaneIsRefusedRatherThanGuessedAt() {
        #expect(TmuxTarget.of("ClaudeContext:@0") == nil)
    }

    @Test func anEmptyAddressIsRefused() {
        #expect(TmuxTarget.of("") == nil)
    }

    @Test func anAddressEndingInADotIsRefused() {
        #expect(TmuxTarget.of("ClaudeContext:@0.") == nil)
    }

    @Test func anAddressBeginningWithADotIsRefused() {
        #expect(TmuxTarget.of(".%0") == nil)
    }

    @Test func surroundingSpaceIsTrimmedRatherThanSentToTmux() {
        #expect(TmuxTarget.of("  ClaudeContext:@0.%0  ")?.pane == "%0")
    }
}
