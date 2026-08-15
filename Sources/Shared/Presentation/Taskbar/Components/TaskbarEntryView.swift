import SwiftUI

struct TaskbarEntryView: View {
    let entry: TaskbarEntryModel
    let preset: BarPreset
    let onActivate: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onActivate) {
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
            .padding(.horizontal, KbSpacing.s4)
            .padding(.vertical, KbSpacing.s3)
            .frame(
                minWidth: preset.entryContent == .iconOnly ? TaskbarMetrics.iconOnlyEntryWidth : TaskbarMetrics.entryCompactWidth,
                maxWidth: preset.entryContent == .iconOnly ? TaskbarMetrics.iconOnlyEntryWidth : TaskbarMetrics.entryMaxWidth
            )
            .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .background(entryBackground)
        .scaleEffect(isHovered ? TaskbarMetrics.hoverScale : 1)
        .animation(KbMotion.quick, value: isHovered)
        .animation(KbMotion.quick, value: entry.isFrontmost)
        .onHover { hovering in
            isHovered = hovering
        }
        .help(entry.title)
    }

    private var entryBackground: some View {
        Capsule().fill(fill)
    }

    private var fill: Color {
        if entry.isFrontmost {
            return KbColors.onSurface.opacity(TaskbarMetrics.focusedFillOpacity)
        }
        return KbColors.onSurface.opacity(isHovered ? TaskbarMetrics.hoverFillOpacity : 0)
    }
}
