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

import Foundation
import Testing

@testable import KcdBarTray

struct LatestTotalsTests {
    private let epoch = Date(timeIntervalSince1970: 0)

    @Test func theFirstReadingIsAlwaysTaken() {
        var latest = LatestTotals()
        let took = latest.accepts(epoch)

        #expect(took)
    }

    @Test func aNewerReadingReplacesTheOneBeforeIt() {
        var latest = LatestTotals()

        _ = latest.accepts(epoch)
        let took = latest.accepts(epoch.addingTimeInterval(60))

        #expect(took)
    }

    @Test func aStaleChannelDoesNotOverwriteTheLiveOne() {
        var latest = LatestTotals()

        _ = latest.accepts(epoch.addingTimeInterval(60))
        let took = latest.accepts(epoch)

        #expect(took == false)
    }

    @Test func theOrderTheChannelsArriveInDoesNotChangeTheWinner() {
        var forwards = LatestTotals()
        var backwards = LatestTotals()

        _ = forwards.accepts(epoch)
        let forwardsTookNewer = forwards.accepts(epoch.addingTimeInterval(60))

        _ = backwards.accepts(epoch.addingTimeInterval(60))
        let backwardsTookOlder = backwards.accepts(epoch)

        #expect(forwardsTookNewer)
        #expect(backwardsTookOlder == false)
    }
}
