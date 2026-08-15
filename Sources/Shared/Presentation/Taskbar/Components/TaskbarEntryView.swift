import SwiftUI

struct TaskbarEntryView: View {
    let entry: TaskbarEntryModel
    let preset: BarPreset
    let onActivate: () -> Void

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
            .fill(fillOpacity)
    }

    private var fillOpacity: Color {
        if entry.isFrontmost {
            return KbColors.onSurface.opacity(0.16)
        }
        if entry.isMinimized {
            return .clear
        }
        return KbColors.onSurface.opacity(0.06)
    }
}
