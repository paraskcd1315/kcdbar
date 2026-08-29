import CoreGraphics
import SwiftUI

package struct TaskbarPreviewThumbnail: Identifiable, Equatable {
    package let id: CGWindowID
    package let size: CGSize
    package let image: Image?
    package var displayName: String? = nil
    package var isFullScreen: Bool = false

    package var hasCaption: Bool {
        isFullScreen || displayName != nil
    }

    package static func thumbnails(
        for windows: [TaskbarPreviewWindow],
        previews: [CGWindowID: Image]
    ) -> [TaskbarPreviewThumbnail] {
        windows
            .prefix(TaskbarPreviewMetrics.maximumThumbnails)
            .map { window in
                TaskbarPreviewThumbnail(
                    id: window.id,
                    size: TaskbarPreviewFit.size(of: window.size, within: TaskbarPreviewMetrics.thumbnailSize),
                    image: previews[window.id],
                    displayName: window.displayName,
                    isFullScreen: window.isFullScreen
                )
            }
    }
}
