import CoreGraphics
import SwiftUI

package struct TaskbarPreviewThumbnail: Identifiable, Equatable {
    package let id: CGWindowID
    package let image: Image?

    package static func thumbnails(
        for windowIds: [CGWindowID],
        previews: [CGWindowID: Image]
    ) -> [TaskbarPreviewThumbnail] {
        windowIds
            .prefix(TaskbarPreviewMetrics.maximumThumbnails)
            .map { TaskbarPreviewThumbnail(id: $0, image: previews[$0]) }
    }
}
