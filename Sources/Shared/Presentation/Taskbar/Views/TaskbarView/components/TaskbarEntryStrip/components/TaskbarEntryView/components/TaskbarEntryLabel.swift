import SwiftUI

struct TaskbarEntryLabel: View {
    let entry: TaskbarEntryModel
    let showsTitle: Bool

    var body: some View {
        HStack(spacing: KbSpacing.s3) {
            TaskbarEntryIcon(icon: entry.icon)
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
