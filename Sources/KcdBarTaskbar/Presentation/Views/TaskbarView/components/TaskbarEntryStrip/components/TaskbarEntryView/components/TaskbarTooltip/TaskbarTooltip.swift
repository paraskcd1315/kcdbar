import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTooltip: View {
    package let applicationName: String
    package let windowTitle: String

    package var body: some View {
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
        .padding(.horizontal, KbSpacing.s5)
        .padding(.vertical, KbSpacing.s3)
        .frame(maxWidth: TaskbarMetrics.tooltipMaxWidth, alignment: .leading)
        .fixedSize()
        .glassEffect(.regular, in: .rect(cornerRadius: KbRadii.md))
        .shadow(
            color: KbColors.scrim,
            radius: TaskbarMetrics.tooltipShadowRadius,
            y: TaskbarMetrics.tooltipShadowOffset
        )
        .allowsHitTesting(false)
    }

    private var showsWindowTitle: Bool {
        !windowTitle.isEmpty && windowTitle != applicationName
    }
}
