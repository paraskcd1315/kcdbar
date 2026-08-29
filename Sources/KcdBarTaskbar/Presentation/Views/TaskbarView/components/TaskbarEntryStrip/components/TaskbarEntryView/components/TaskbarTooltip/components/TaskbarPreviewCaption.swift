import KcdBarDesignSystem
import SwiftUI

package struct TaskbarPreviewCaption: View {
    package let thumbnail: TaskbarPreviewThumbnail

    package var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title = thumbnail.title, !title.isEmpty {
                HStack(spacing: KbSpacing.s1) {
                    Text(title)
                        .foregroundStyle(KbColors.onSurface)
                    if let profile = thumbnail.profile {
                        Text(verbatim: "·")
                            .foregroundStyle(KbColors.onSurfaceMuted)
                        Text(profile)
                            .foregroundStyle(KbColors.onSurfaceMuted)
                    }
                }
            }
            if thumbnail.isFullScreen || thumbnail.displayName != nil {
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
                .foregroundStyle(KbColors.onSurfaceMuted)
            }
        }
        .font(KbTypography.clockDate)
        .lineLimit(1)
        .padding(.horizontal, KbSpacing.s2)
        .padding(.vertical, KbSpacing.s1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(KbColors.focusedFill)
    }
}
