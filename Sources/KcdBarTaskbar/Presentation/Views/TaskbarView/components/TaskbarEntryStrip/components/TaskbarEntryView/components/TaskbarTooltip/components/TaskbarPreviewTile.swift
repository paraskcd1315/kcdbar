import KcdBarDesignSystem
import SwiftUI

package struct TaskbarPreviewTile: View {
    package let thumbnail: TaskbarPreviewThumbnail
    package let icon: Image?
    package let onTap: () -> Void
    package let onClose: () -> Void

    @State private var isHovered = false

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
        .frame(width: thumbnail.size.width, height: thumbnail.size.height)
        .overlay(alignment: .bottom) {
            if thumbnail.hasCaption {
                TaskbarPreviewCaption(thumbnail: thumbnail)
            }
        }
        .clipShape(.rect(cornerRadius: TaskbarPreviewMetrics.thumbnailCornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: TaskbarPreviewMetrics.thumbnailCornerRadius)
                .strokeBorder(
                    isHovered ? KbColors.activeIndicator : KbColors.separator,
                    lineWidth: isHovered ? TaskbarMetrics.openBorderHeight : TaskbarMetrics.separatorThickness
                )
        }
        .overlay(alignment: .topTrailing) {
            if isHovered {
                TaskbarPreviewClose(onClose: onClose)
                    .padding(KbSpacing.s2)
            }
        }
        .contentShape(.rect(cornerRadius: TaskbarPreviewMetrics.thumbnailCornerRadius))
        .onTapGesture(perform: onTap)
        .onHover { isHovered = $0 }
        .scaleEffect(isHovered ? TaskbarMetrics.previewHoverScale : 1)
        .animation(KbMotion.quick, value: isHovered)
    }
}
