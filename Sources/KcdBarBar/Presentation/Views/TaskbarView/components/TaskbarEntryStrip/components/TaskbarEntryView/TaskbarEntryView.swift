import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryView: View {
    package let entry: TaskbarEntryModel
    package let preset: BarPreset
    package let isDragging: Bool
    package let onActivate: () -> Void
    package let onTogglePin: () -> Void
    package let onMiddleClick: () -> Void

    @Environment(\.middleClickCatcher) private var middleClickCatcher

    @State private var isHovered = false
    @State private var showsTooltip = false

    package var body: some View {
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
        .opacity(isDragging ? TaskbarMetrics.draggingOpacity : 1)
        .animation(KbMotion.quick, value: isHovered)
        .animation(KbMotion.quick, value: entry.isFrontmost)
        .animation(KbMotion.quick, value: isDragging)
        .overlay(alignment: TaskbarEntryStyle.tooltipAlignment(edge: preset.edge)) {
            if showsTooltip, !isDragging {
                TaskbarEntryTooltip(entry: entry, edge: preset.edge)
            }
        }
        .onHover { isHovered = $0 }
        .task(id: isHovered) { await revealTooltip() }
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
