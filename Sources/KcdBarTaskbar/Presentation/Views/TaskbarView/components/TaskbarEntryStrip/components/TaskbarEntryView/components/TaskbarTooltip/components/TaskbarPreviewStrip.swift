import SwiftUI

package struct TaskbarPreviewStrip: View {
    package let thumbnails: [TaskbarPreviewThumbnail]
    package let icon: Image?
    package let onRaiseWindow: (CGWindowID) -> Void

    package var body: some View {
        HStack(spacing: TaskbarPreviewMetrics.thumbnailSpacing) {
            ForEach(thumbnails) { thumbnail in
                TaskbarPreviewTile(thumbnail: thumbnail, icon: icon) {
                    onRaiseWindow(thumbnail.id)
                }
            }
        }
    }
}
