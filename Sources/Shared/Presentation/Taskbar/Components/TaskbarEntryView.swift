import SwiftUI

struct TaskbarEntryView: View {
    let entry: TaskbarEntryModel
    let preset: BarPreset
    let onActivate: () -> Void
    let onTogglePin: () -> Void
    let onDropPin: (String) -> Void

    @State private var isHovered = false
    @State private var isDropTarget = false
    @State private var isDragging = false
    @State private var showsTooltip = false

    var body: some View {
        Button(action: onActivate) {
            HStack(spacing: KbSpacing.s3) {
                TaskbarEntryIcon(icon: entry.icon)
                if preset.entryContent != .iconOnly && !entry.isLauncher {
                    Text(entry.title)
                        .font(entry.isFrontmost ? KbTypography.entryTitleActive : KbTypography.entryTitle)
                        .foregroundStyle(entry.isMinimized ? KbColors.onSurfaceMuted : KbColors.onSurface)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .frame(maxWidth: .infinity, alignment: showsTitle ? .leading : .center)
            .padding(.horizontal, showsTitle ? KbSpacing.s4 : KbSpacing.s2)
            .padding(.vertical, KbSpacing.s2)
            .frame(
                minWidth: showsTitle ? TaskbarMetrics.entryCompactWidth : TaskbarMetrics.iconOnlyEntryWidth,
                maxWidth: showsTitle ? TaskbarMetrics.entryMaxWidth : TaskbarMetrics.iconOnlyEntryWidth
            )
            .contentShape(.rect(cornerRadius: KbRadii.md))
        }
        .buttonStyle(.plain)
        .glassEffect(entryGlass, in: .rect(cornerRadius: KbRadii.md))
        .scaleEffect(isHovered ? TaskbarMetrics.hoverScale : 1)
        .animation(KbMotion.quick, value: isHovered)
        .animation(KbMotion.quick, value: entry.isFrontmost)
        .overlay(alignment: tooltipAlignment) {
            if showsTooltip {
                TaskbarTooltip(
                    applicationName: entry.applicationName,
                    windowTitle: entry.title
                )
                    .offset(tooltipOffset)
                    .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .onHover { hovering in
            isHovered = hovering
        }
        .task(id: isHovered) {
            guard isHovered, !entry.applicationName.isEmpty || !entry.title.isEmpty else {
                showsTooltip = false
                return
            }
            try? await Task.sleep(for: TaskbarMetrics.tooltipDelay)
            guard !Task.isCancelled else { return }
            withAnimation(KbMotion.quick) { showsTooltip = true }
        }
        .padding(.leading, isDropTarget ? TaskbarMetrics.dropGap : 0)
        .overlay(alignment: .leading) {
            if isDropTarget {
                RoundedRectangle(cornerRadius: TaskbarMetrics.dropIndicatorWidth / 2)
                    .fill(KbColors.activeIndicator)
                    .frame(width: TaskbarMetrics.dropIndicatorWidth)
                    .transition(.opacity.combined(with: .scale(scale: 0.4)))
            }
        }
        .animation(KbMotion.quick, value: isDropTarget)
        .opacity(isDragging ? TaskbarMetrics.draggingOpacity : 1)
        .animation(KbMotion.quick, value: isDragging)
        .draggable(entry.bundleIdentifier ?? entry.id) {
            isDragging = true
            return TaskbarEntryIcon(icon: entry.icon)
        }
        .dropDestination(for: String.self) { items, _ in
            guard let dropped = items.first else { return false }
            isDragging = false
            onDropPin(dropped)
            return true
        } isTargeted: { targeted in
            isDropTarget = targeted && entry.isPinned
        }
        .contextMenu {
            if entry.bundleIdentifier != nil {
                Button(entry.isPinned ? "taskbar.menu.unpin" : "taskbar.menu.pin", action: onTogglePin)
            }
        }
    }

    private var tooltipAlignment: Alignment {
        switch preset.edge {
        case .bottom: .top
        case .top: .bottom
        case .leading: .trailing
        case .trailing: .leading
        }
    }

    private var tooltipOffset: CGSize {
        let gap = TaskbarMetrics.tooltipGap
        switch preset.edge {
        case .bottom: return CGSize(width: 0, height: -(TaskbarMetrics.tooltipAllowance - gap))
        case .top: return CGSize(width: 0, height: TaskbarMetrics.tooltipAllowance - gap)
        case .leading: return CGSize(width: TaskbarMetrics.tooltipAllowance - gap, height: 0)
        case .trailing: return CGSize(width: -(TaskbarMetrics.tooltipAllowance - gap), height: 0)
        }
    }

    private var showsTitle: Bool {
        preset.entryContent != .iconOnly && !entry.isLauncher
    }

    private var entryGlass: Glass {
        if entry.isFrontmost {
            return .regular.tint(KbColors.onSurface.opacity(TaskbarMetrics.focusedFillOpacity)).interactive()
        }
        if isHovered {
            return .regular.interactive()
        }
        return .identity
    }
}
