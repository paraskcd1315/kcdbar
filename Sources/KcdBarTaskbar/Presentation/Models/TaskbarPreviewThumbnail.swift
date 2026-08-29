import CoreGraphics
import SwiftUI

package struct TaskbarPreviewThumbnail: Identifiable, Equatable {
    package let id: CGWindowID
    package let size: CGSize
    package let image: Image?
    package var displayName: String? = nil
    package var isFullScreen: Bool = false
    package var title: String? = nil
    package var profile: String? = nil

    package var hasCaption: Bool {
        isFullScreen || displayName != nil || !(title ?? "").isEmpty
    }

    package static func thumbnails(
        for windows: [TaskbarPreviewWindow],
        previews: [CGWindowID: WindowPreview]
    ) -> [TaskbarPreviewThumbnail] {
        windows
            .prefix(TaskbarPreviewMetrics.maximumThumbnails)
            .map { window in
                let preview = previews[window.id]
                return TaskbarPreviewThumbnail(
                    id: window.id,
                    size: TaskbarPreviewFit.size(
                        of: preview?.pixelSize ?? window.size,
                        within: TaskbarPreviewMetrics.thumbnailSize
                    ),
                    image: preview?.image,
                    displayName: window.displayName,
                    isFullScreen: window.isFullScreen,
                    title: window.title,
                    profile: window.profile
                )
            }
    }
}
