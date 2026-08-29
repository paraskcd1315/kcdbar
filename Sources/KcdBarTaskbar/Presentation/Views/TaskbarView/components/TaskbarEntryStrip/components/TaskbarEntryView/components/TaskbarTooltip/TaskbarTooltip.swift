import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTooltip: View {
    package let applicationName: String
    package let windowTitle: String
    package let thumbnails: [TaskbarPreviewThumbnail]
    package let icon: Image?
    package let onRaiseWindow: (CGWindowID) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            if !thumbnails.isEmpty {
                TaskbarPreviewStrip(thumbnails: thumbnails, icon: icon, onRaiseWindow: onRaiseWindow)
            }
            VStack(alignment: .leading, spacing: KbSpacing.s1) {
                Text(applicationName)
                    .font(KbTypography.entryTitleActive)
                    .foregroundStyle(KbColors.onSurface)
                if showsWindowTitle {
                    Text(windowTitle)
                        .font(KbTypography.entryTitle)
                        .foregroundStyle(KbColors.onSurfaceMuted)
                }
            }
            .lineLimit(1)
            .frame(maxWidth: TaskbarMetrics.tooltipMaxWidth, alignment: .leading)
        }
        .padding(.horizontal, KbSpacing.s5)
        .padding(.vertical, KbSpacing.s3)
        .fixedSize()
        .glassEffect(.regular, in: .rect(cornerRadius: KbRadii.md))
        .shadow(
            color: KbColors.scrim,
            radius: TaskbarMetrics.tooltipShadowRadius,
            y: TaskbarMetrics.tooltipShadowOffset
        )
    }

    private var showsWindowTitle: Bool {
        !windowTitle.isEmpty && windowTitle != applicationName
    }
}
