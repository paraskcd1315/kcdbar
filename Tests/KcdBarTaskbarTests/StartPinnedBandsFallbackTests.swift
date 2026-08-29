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
@testable import KcdBarTaskbar

struct StartPinnedBandsFallbackTests {
    private func pin(_ identifier: String, _ order: Int) -> PinnedApp {
        PinnedApp(bundleIdentifier: identifier, displayName: identifier, order: order)
    }

    @Test func aPinShowsTheMomentItIsPinned() {
        let bands = StartPinnedSections.bands(pins: [pin("whatsapp", 0)], groups: [], memberships: [])

        #expect(bands.map(\.group.id) == [StartGroupMetrics.defaultGroupId])
        #expect(bands.first?.applications.map(\.bundleIdentifier) == ["whatsapp"])
    }

    @Test func anUnseededPinJoinsTheDefaultBandBehindTheOnesAlreadyThere() {
        let bands = StartPinnedSections.bands(
            pins: [pin("held", 0), pin("fresh", 1)],
            groups: [
                StartGroup(id: StartGroupMetrics.defaultGroupId, order: 0),
                StartGroup(id: "custom.work", order: 1)
            ],
            memberships: [
                StartGroupMembership(
                    bundleIdentifier: "held",
                    groupId: StartGroupMetrics.defaultGroupId,
                    order: 0
                )
            ]
        )

        #expect(bands.first?.applications.map(\.bundleIdentifier) == ["held", "fresh"])
    }

    @Test func aPinAlreadyLivingInACustomBandIsNotPulledBack() {
        let bands = StartPinnedSections.bands(
            pins: [pin("a", 0)],
            groups: [StartGroup(id: "custom.work", order: 0)],
            memberships: [
                StartGroupMembership(bundleIdentifier: "a", groupId: "custom.work", order: 0)
            ]
        )

        #expect(bands.map(\.group.id) == ["custom.work"])
        #expect(bands.first?.applications.count == 1)
    }
}
