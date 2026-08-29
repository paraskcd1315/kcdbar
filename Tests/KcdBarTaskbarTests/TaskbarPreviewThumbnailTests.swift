import CoreGraphics
import SwiftUI
import Testing

@testable import KcdBarTaskbar

struct TaskbarPreviewThumbnailTests {
    private let image = Image(systemName: "rectangle")

    @Test func aThumbnailKeepsTheWindowOrderTheEntryGaveIt() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(
            for: [12, 10, 11],
            previews: [:]
        )

        #expect(thumbnails.map(\.id) == [12, 10, 11])
    }

    @Test func aWindowWithNoCaptureStillGetsATile() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(
            for: [10, 11],
            previews: [10: image]
        )

        #expect(thumbnails.count == 2)
        #expect(thumbnails[1].image == nil)
    }

    @Test func aGroupedEntryDrawsNoMoreTilesThanItMayShow() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(
            for: [10, 11, 12, 13, 14, 15],
            previews: [:]
        )

        #expect(thumbnails.count == TaskbarPreviewMetrics.maximumThumbnails)
    }

    @Test func anEntryWithNoWindowDrawsNoTiles() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(for: [], previews: [10: image])

        #expect(thumbnails.isEmpty)
    }
}
