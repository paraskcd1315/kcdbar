import SwiftUI

struct TaskbarEntryView: View {
    let entry: TaskbarEntryModel
    let preset: BarPreset
    let onActivate: () -> Void
    let onTogglePin: () -> Void
    let onDropPin: (String) -> Void

    @State private var isHovered = false
    @State private var isDropTarget = false
    @State private var showsTooltip = false

    var body: some View {
        content
            .contentShape(entryShape)
            .onTapGesture(perform: onActivate)
            .glassEffect(entryGlass, in: entryShape)
            .scaleEffect(isHovered ? TaskbarMetrics.hoverScale : 1)
            .animation(KbMotion.quick, value: isHovered)
            .animation(KbMotion.quick, value: entry.isFrontmost)
            .overlay(alignment: tooltipAlignment) { tooltip }
            .onHover { isHovered = $0 }
            .task(id: isHovered) { await revealTooltip() }
            .padding(.leading, isDropTarget ? TaskbarMetrics.dropGap : 0)
            .overlay(alignment: .leading) { dropIndicator }
            .animation(KbMotion.quick, value: isDropTarget)
            .draggable(entry.orderingKey) {
                TaskbarEntryIcon(icon: entry.icon)
            }
            .dropDestination(for: String.self) { items, _ in
                guard let dropped = items.first else { return false }
                onDropPin(dropped)
                return true
            } isTargeted: { targeted in
                isDropTarget = targeted
            }
            .contextMenu {
                if entry.bundleIdentifier != nil {
                    Button(entry.isPinned ? "taskbar.menu.unpin" : "taskbar.menu.pin", action: onTogglePin)
                }
            }
    }

    private var content: some View {
        entryBody
            .overlay(alignment: .bottom) {
                if isOpen {
                    VStack(spacing: TaskbarMetrics.instanceDotInset) {
                        TaskbarInstanceDots(count: entry.instanceCount, isFrontmost: entry.isFrontmost)
                        Rectangle()
                            .fill(entry.isFrontmost ? KbColors.activeIndicator : KbColors.onSurfaceMuted)
                            .frame(height: TaskbarMetrics.openBorderHeight)
                    }
                }
            }
    }

    private var isOpen: Bool {
        entry.instanceCount > 0
    }

    private var entryShape: AnyShape {
        guard isOpen else { return AnyShape(RoundedRectangle(cornerRadius: KbRadii.md)) }

        return AnyShape(
            UnevenRoundedRectangle(
                topLeadingRadius: KbRadii.md,
                topTrailingRadius: KbRadii.md
            )
        )
    }

    private var entryBody: some View {
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

    @ViewBuilder
    private var tooltip: some View {
        if showsTooltip {
            TaskbarTooltip(applicationName: entry.applicationName, windowTitle: entry.title)
                .offset(tooltipOffset)
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
        }
    }

    @ViewBuilder
    private var dropIndicator: some View {
        if isDropTarget {
            RoundedRectangle(cornerRadius: TaskbarMetrics.dropIndicatorWidth / 2)
                .fill(KbColors.activeIndicator)
                .frame(width: TaskbarMetrics.dropIndicatorWidth)
                .transition(.opacity.combined(with: .scale(scale: 0.4)))
        }
    }

    private func revealTooltip() async {
        guard isHovered, !entry.applicationName.isEmpty || !entry.title.isEmpty else {
            showsTooltip = false
            return
        }
        try? await Task.sleep(for: TaskbarMetrics.tooltipDelay)
        guard !Task.isCancelled else { return }
        withAnimation(KbMotion.quick) { showsTooltip = true }
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
        let travel = TaskbarMetrics.tooltipAllowance - TaskbarMetrics.tooltipGap
        switch preset.edge {
        case .bottom: return CGSize(width: 0, height: -travel)
        case .top: return CGSize(width: 0, height: travel)
        case .leading: return CGSize(width: travel, height: 0)
        case .trailing: return CGSize(width: -travel, height: 0)
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
