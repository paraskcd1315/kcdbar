import CoreGraphics
import Testing

@testable import KcdBarTaskbar

struct TaskbarPreviewFitTests {
    private let ceiling = CGSize(width: 168, height: 104)

    @Test func aWideWindowFillsTheWidthAndKeepsItsShape() {
        let size = TaskbarPreviewFit.size(of: CGSize(width: 1920, height: 1030), within: ceiling)

        #expect(size == CGSize(width: 168, height: 90))
    }

    @Test func aTallWindowFillsTheHeightAndKeepsItsShape() {
        let size = TaskbarPreviewFit.size(of: CGSize(width: 600, height: 900), within: ceiling)

        #expect(size == CGSize(width: 69, height: 104))
    }

    @Test func aWindowSmallerThanTheCeilingDrawsAtItsOwnSize() {
        let size = TaskbarPreviewFit.size(of: CGSize(width: 120, height: 80), within: ceiling)

        #expect(size == CGSize(width: 120, height: 80))
    }

    @Test func aWindowWithNoSizeTakesTheCeiling() {
        #expect(TaskbarPreviewFit.size(of: .zero, within: ceiling) == ceiling)
    }

    @Test func aThumbnailCarriesTheFittedSizeOfItsWindow() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(
            for: [TaskbarPreviewWindow(id: 10, size: CGSize(width: 1920, height: 1030))],
            previews: [:]
        )

        #expect(thumbnails.first?.size == CGSize(width: 168, height: 90))
    }

    @Test func aThumbnailCarriesItsWindowsDisplayAndFullScreenState() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(
            for: [TaskbarPreviewWindow(
                id: 10, size: CGSize(width: 800, height: 600), displayName: "Left", isFullScreen: true)],
            previews: [:]
        )

        #expect(thumbnails.first?.displayName == "Left")
        #expect(thumbnails.first?.isFullScreen == true)
        #expect(thumbnails.first?.hasCaption == true)
    }

    @Test func aThumbnailOnThisDisplayInAWindowWithNoTitleHasNoCaption() {
        let thumbnails = TaskbarPreviewThumbnail.thumbnails(
            for: [TaskbarPreviewWindow(id: 10, size: CGSize(width: 800, height: 600))],
            previews: [:]
        )

        #expect(thumbnails.first?.hasCaption == false)
    }
}
