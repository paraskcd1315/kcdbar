import KcdBarDesignSystem
import SwiftUI

package struct TaskbarPreviewCaption: View {
    package let thumbnail: TaskbarPreviewThumbnail

    package var body: some View {
        HStack(spacing: KbSpacing.s1) {
            if thumbnail.isFullScreen {
                Image(systemName: TaskbarMetrics.fullScreenBadgeSymbol)
                    .font(.system(size: TaskbarMetrics.fullScreenBadgeGlyph, weight: .bold))
                Text(LocalizedStringKey.catalogue("preview", "fullScreen"))
            }
            if let displayName = thumbnail.displayName {
                if thumbnail.isFullScreen {
                    Text(verbatim: "·")
                }
                Text(displayName)
            }
        }
        .font(KbTypography.clockDate)
        .foregroundStyle(KbColors.onSurface)
        .lineLimit(1)
        .padding(.horizontal, KbSpacing.s2)
        .padding(.vertical, KbSpacing.s1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(KbColors.scrim)
    }
}
