import KcdBarDesignSystem
import SwiftUI

package struct TaskbarPreviewTile: View {
    package let thumbnail: TaskbarPreviewThumbnail
    package let icon: Image?

    package var body: some View {
        ZStack {
            KbColors.bandFill
            if let image = thumbnail.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if let icon {
                icon
                    .resizable()
                    .frame(
                        width: TaskbarPreviewMetrics.fallbackIconSide,
                        height: TaskbarPreviewMetrics.fallbackIconSide
                    )
            }
        }
        .frame(
            width: TaskbarPreviewMetrics.thumbnailWidth,
            height: TaskbarPreviewMetrics.thumbnailHeight
        )
        .clipShape(.rect(cornerRadius: TaskbarPreviewMetrics.thumbnailCornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: TaskbarPreviewMetrics.thumbnailCornerRadius)
                .strokeBorder(KbColors.separator, lineWidth: TaskbarMetrics.separatorThickness)
        }
    }
}
