import SwiftUI

struct TaskbarEntryStrip: View {
    let entries: [TaskbarEntryModel]
    let preset: BarPreset
    let onActivate: (TaskbarEntryModel) -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void
    let onMiddleClick: (TaskbarEntryModel) -> Void

    @State private var slots: [String: CGRect] = [:]
    @State private var dragSlots: [String: CGRect] = [:]
    @State private var dragging: String?
    @State private var over: String?

    var body: some View {
        KbAxisStack(isVertical: preset.edge.isVertical, spacing: preset.entrySpacing) {
            ForEach(previewed) { entry in
                TaskbarEntryView(
                    entry: entry,
                    preset: preset,
                    isDragging: dragging == entry.orderingKey,
                    onActivate: { onActivate(entry) },
                    onTogglePin: { onTogglePin(entry) },
                    onMiddleClick: { onMiddleClick(entry) }
                )
                .onGeometryChange(for: CGRect.self) { proxy in
                    proxy.frame(in: .named(TaskbarStripLayout.coordinateSpace))
                } action: { frame in
                    slots[entry.orderingKey] = frame
                }
                .gesture(reorderGesture(for: entry))
                .transition(TaskbarStripLayout.insertion)
            }
        }
        .coordinateSpace(.named(TaskbarStripLayout.coordinateSpace))
        .animation(KbMotion.standard, value: entries)
        .animation(KbMotion.standard, value: previewed.map(\.id))
        .frame(
            maxWidth: expandsAlongBar && !preset.edge.isVertical ? .infinity : nil,
            maxHeight: expandsAlongBar && preset.edge.isVertical ? .infinity : nil,
            alignment: TaskbarStripLayout.alignment(preset: preset)
        )
    }

    private var previewed: [TaskbarEntryModel] {
        TaskbarDragReorder.preview(entries: entries, dragging: dragging, over: over)
    }

    private var expandsAlongBar: Bool {
        TaskbarStripLayout.expandsAlongBar(preset: preset)
    }

    private func reorderGesture(for entry: TaskbarEntryModel) -> some Gesture {
        DragGesture(
            minimumDistance: TaskbarMetrics.dragActivationDistance,
            coordinateSpace: .named(TaskbarStripLayout.coordinateSpace)
        )
        .onChanged { value in
            if dragging == nil {
                dragging = entry.orderingKey
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
