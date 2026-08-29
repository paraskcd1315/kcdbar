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

struct TotalsChannelsTests {
    private func folder(containing names: [String]) throws -> URL {
        let root = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("totals-channels-\(UUID().uuidString)", isDirectory: true)

        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)

        for name in names {
            try Data("{}".utf8).write(to: root.appendingPathComponent(name))
        }

        return root
    }

    @Test func everyTrackerUnderThePrefixIsFound() throws {
        let root = try folder(containing: ["totals.toggl.json", "totals.kimai.json"])

        #expect(TotalsChannels.onDisk(in: root) == ["totals.kimai", "totals.toggl"])
    }

    @Test func aTrackerNobodyHasHeardOfIsFoundToo() throws {
        let root = try folder(containing: ["totals.harvest.json"])

        #expect(TotalsChannels.onDisk(in: root) == ["totals.harvest"])
    }

    @Test func anUnsuffixedTotalsChannelCounts() throws {
        let root = try folder(containing: ["totals.json"])

        #expect(TotalsChannels.onDisk(in: root) == ["totals"])
    }

    @Test func otherChannelsAreLeftAlone() throws {
        let root = try folder(containing: ["timer.json", "totalsomething.json", "totals.toggl.json"])

        #expect(TotalsChannels.onDisk(in: root) == ["totals.toggl"])
    }

    @Test func anEmptyFolderYieldsNothingRatherThanFailing() throws {
        let root = try folder(containing: [])

        #expect(TotalsChannels.onDisk(in: root).isEmpty)
    }

    @Test func aFolderThatDoesNotExistYieldsNothing() {
        let missing = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("no-such-\(UUID().uuidString)", isDirectory: true)

        #expect(TotalsChannels.onDisk(in: missing).isEmpty)
    }
}
