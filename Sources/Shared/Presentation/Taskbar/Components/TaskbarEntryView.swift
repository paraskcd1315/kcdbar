import SwiftUI

struct TaskbarEntryView: View {
    let entry: TaskbarEntryModel
    let preset: BarPreset
    let onActivate: () -> Void

    var body: some View {
        Button(action: onActivate) {
            VStack(spacing: KbSpacing.s1) {
                HStack(spacing: KbSpacing.s3) {
                    TaskbarEntryIcon(icon: entry.icon)
                    if preset.entryContent != .iconOnly {
                        Text(entry.title)
                            .font(entry.isFrontmost ? KbTypography.entryTitleActive : KbTypography.entryTitle)
                            .foregroundStyle(entry.isMinimized ? KbColors.onSurfaceMuted : KbColors.onSurface)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if preset.entryContent != .iconOnly {
                    TaskbarEntryIndicator(isFrontmost: entry.isFrontmost, isMinimized: entry.isMinimized)
                }
            }
            .padding(.horizontal, KbSpacing.s3)
            .padding(.vertical, KbSpacing.s2)
            .frame(
                minWidth: preset.entryContent == .iconOnly ? TaskbarMetrics.iconOnlyEntryWidth : TaskbarMetrics.entryMinWidth,
                maxWidth: preset.entryContent == .iconOnly ? TaskbarMetrics.iconOnlyEntryWidth : TaskbarMetrics.entryMaxWidth
            )
            .contentShape(.rect(cornerRadius: KbRadii.sm))
        }
        .buttonStyle(.plain)
        .background(entryBackground)
        .help(entry.title)
    }

    private var entryBackground: some View {
        RoundedRectangle(cornerRadius: KbRadii.sm)
            .fill(entry.isFrontmost ? KbColors.separator : .clear)
    }
}
