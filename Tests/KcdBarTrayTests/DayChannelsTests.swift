import Foundation
import Testing

@testable import KcdBarTray

struct DayChannelsTests {
    private func folder(containing names: [String]) throws -> URL {
        let root = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("day-channels-\(UUID().uuidString)", isDirectory: true)

        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)

        for name in names {
            try Data("{}".utf8).write(to: root.appendingPathComponent(name))
        }

        return root
    }

    @Test func everyTrackerUnderThePrefixIsFound() throws {
        let root = try folder(containing: ["day.toggl.json", "day.kimai.json"])

        #expect(DayChannels.onDisk(in: root) == ["day.kimai", "day.toggl"])
    }

    @Test func aTrackerNobodyHasHeardOfIsFoundToo() throws {
        let root = try folder(containing: ["day.harvest.json"])

        #expect(DayChannels.onDisk(in: root) == ["day.harvest"])
    }

    @Test func anUnsuffixedDayChannelCounts() throws {
        let root = try folder(containing: ["day.json"])

        #expect(DayChannels.onDisk(in: root) == ["day"])
    }

    @Test func theTotalsAndTimerChannelsBesideItAreLeftAlone() throws {
        let root = try folder(
            containing: ["timer.json", "totals.toggl.json", "daybreak.json", "day.toggl.json"])

        #expect(DayChannels.onDisk(in: root) == ["day.toggl"])
    }

    @Test func anEmptyFolderYieldsNothingRatherThanFailing() throws {
        let root = try folder(containing: [])

        #expect(DayChannels.onDisk(in: root).isEmpty)
    }

    @Test func aFolderThatDoesNotExistYieldsNothing() {
        let missing = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("no-such-\(UUID().uuidString)", isDirectory: true)

        #expect(DayChannels.onDisk(in: missing).isEmpty)
    }
}
