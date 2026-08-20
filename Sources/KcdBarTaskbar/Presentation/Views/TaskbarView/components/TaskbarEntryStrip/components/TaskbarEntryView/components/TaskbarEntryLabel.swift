import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryLabel: View {
    package let entry: TaskbarEntryModel
    package let showsTitle: Bool
    package let iconSize: CGFloat

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            TaskbarEntryIcon(icon: entry.icon, size: iconSize)
            if showsTitle {
                Text(entry.title)
                    .font(entry.isFrontmost ? KbTypography.entryTitleActive : KbTypography.entryTitle)
                    .foregroundStyle(entry.isMinimized ? KbColors.onSurfaceMuted : KbColors.onSurface)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
        .frame(maxWidth: showsTitle ? .infinity : nil, alignment: showsTitle ? .leading : .center)
        .padding(.horizontal, showsTitle ? KbSpacing.s4 : KbSpacing.s3)
        .padding(.vertical, KbSpacing.s3)
        .frame(
            minWidth: showsTitle ? TaskbarMetrics.entryCompactWidth : nil,
            maxWidth: showsTitle ? TaskbarMetrics.entryMaxWidth : nil
        )
    }
}
