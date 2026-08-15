import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryStrip: View {
    package let entries: [TaskbarEntryModel]
    package let preset: BarPreset
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onCloseWindow: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onDropPin: (String, TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void

    @State private var slots: [String: CGRect] = [:]
    @State private var dragSlots: [String: CGRect] = [:]
    @State private var dragging: String?
    @State private var over: String?

    package var body: some View {
        KbAxisStack(isVertical: preset.edge.isVertical, spacing: preset.entrySpacing) {
            ForEach(groups) { group in
                TaskbarEntryBand(
                    group: group,
                    preset: preset,
                    isDragging: dragging == group.id,
                    onActivate: onActivate,
                    onTogglePin: onTogglePin,
                    onCloseWindow: onCloseWindow,
                    onQuit: onQuit,
                    onMiddleClick: onMiddleClick
                )
                .onGeometryChange(for: CGRect.self) { proxy in
                    proxy.frame(in: .named(TaskbarStripLayout.coordinateSpace))
                } action: { frame in
                    slots[group.id] = frame
                }
                .gesture(reorderGesture(for: group))
                .transition(TaskbarStripLayout.insertion)
            }
        }
        .coordinateSpace(.named(TaskbarStripLayout.coordinateSpace))
        .animation(KbMotion.standard, value: entries)
        .animation(KbMotion.standard, value: groups.map(\.id))
        .frame(
            maxWidth: expandsAlongBar && !preset.edge.isVertical ? .infinity : nil,
            maxHeight: expandsAlongBar && preset.edge.isVertical ? .infinity : nil,
            alignment: TaskbarStripLayout.alignment(preset: preset)
        )
    }

    private var groups: [TaskbarEntryGroup] {
        TaskbarEntryGrouping.groups(
            from: TaskbarDragReorder.preview(entries: entries, dragging: dragging, over: over)
        )
    }

    private var expandsAlongBar: Bool {
        TaskbarStripLayout.expandsAlongBar(preset: preset)
    }

    private func reorderGesture(for group: TaskbarEntryGroup) -> some Gesture {
        DragGesture(
            minimumDistance: TaskbarMetrics.dragActivationDistance,
            coordinateSpace: .named(TaskbarStripLayout.coordinateSpace)
        )
        .onChanged { value in
            if dragging == nil {
                dragging = group.id
                dragSlots = slots
            }
            over = TaskbarDragHitTest.key(at: value.location, in: dragSlots, dragging: dragging)
        }
        .onEnded { _ in commit() }
    }

    private func commit() {
        defer {
            dragging = nil
            over = nil
            dragSlots = [:]
        }
        guard let dragging, let over, let target = entries.first(where: { $0.orderingKey == over }) else {
            return
        }
        onDropPin(dragging, target)
    }
}
