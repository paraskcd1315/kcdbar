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

struct WindowSpacePolicyTests {
    private func window(zOrder: Int?, source: WindowRecordSource = .both) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: 1, cgWindowId: 1, fallbackKey: "1"),
            ownerPid: 1,
            ownerName: "App",
            title: "W",
            bounds: WindowFixtures.defaultBounds,
            isMinimized: false,
            isFullScreen: false,
            isOnScreen: true,
            zOrder: zOrder,
            source: source
        )
    }

    @Test func aPromotedWindowIsNotOnTheActiveSpaceWhateverItsRank() {
        #expect(WindowSpacePolicy.isOnActiveSpace(window(zOrder: 3, source: .inactiveSpace)) == false)
    }

    @Test func aRankedWindowIsOnTheActiveSpace() {
        #expect(WindowSpacePolicy.isOnActiveSpace(window(zOrder: 3)))
    }

    @Test func theSentinelRankMeansAnotherSpace() {
        #expect(WindowSpacePolicy.isOnActiveSpace(window(zOrder: Int.max)) == false)
    }

    @Test func anUnrankedWindowIsNotOnTheActiveSpace() {
        #expect(WindowSpacePolicy.isOnActiveSpace(window(zOrder: nil)) == false)
    }
}
