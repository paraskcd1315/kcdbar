import SwiftUI

struct TaskbarEntryView: View {
    let entry: TaskbarEntryModel
    let preset: BarPreset
    let onActivate: () -> Void
    let onTogglePin: () -> Void
    let onDropPin: (String) -> Void
    let onMiddleClick: () -> Void

    @Environment(\.middleClickCatcher) private var middleClickCatcher

    @State private var isHovered = false
    @State private var isDropTarget = false
    @State private var showsTooltip = false

    var body: some View {
        TaskbarEntryLabel(
            entry: entry,
            showsTitle: TaskbarEntryStyle.showsTitle(
                content: preset.entryContent,
                isLauncher: entry.isLauncher
            )
        )
        .overlay(alignment: .bottom) { TaskbarEntryIndicator(entry: entry) }
        .contentShape(shape)
        .overlay { middleClickCatcher(onMiddleClick) }
        .onTapGesture(perform: onActivate)
        .glassEffect(TaskbarEntryStyle.glass(isFrontmost: entry.isFrontmost, isHovered: isHovered), in: shape)
        .animation(KbMotion.quick, value: isHovered)
        .animation(KbMotion.quick, value: entry.isFrontmost)
        .overlay(alignment: TaskbarEntryStyle.tooltipAlignment(edge: preset.edge)) {
            if showsTooltip {
                TaskbarEntryTooltip(entry: entry, edge: preset.edge)
            }
        }
        .onHover { isHovered = $0 }
        .task(id: isHovered) { await revealTooltip() }
        .padding(.leading, isDropTarget ? TaskbarMetrics.dropGap : 0)
        .overlay(alignment: .leading) {
            if isDropTarget {
                TaskbarDropIndicator()
            }
        }
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

    private var shape: AnyShape {
        TaskbarEntryStyle.shape(isOpenHere: TaskbarEntryStyle.isOpenHere(entry))
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
}
