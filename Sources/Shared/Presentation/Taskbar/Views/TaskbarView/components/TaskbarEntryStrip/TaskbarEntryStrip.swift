import SwiftUI

struct TaskbarEntryStrip: View {
    let entries: [TaskbarEntryModel]
    let preset: BarPreset
    let onActivate: (TaskbarEntryModel) -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void
    let onMiddleClick: (TaskbarEntryModel) -> Void

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
                    onDragStart: { beginDrag(entry) },
                    onTargeted: { targeted in retarget(entry, isTargeted: targeted) },
                    onDropPin: { dropped in commit(dropped, on: entry) },
                    onMiddleClick: { onMiddleClick(entry) }
                )
                .transition(TaskbarStripLayout.insertion)
            }
        }
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

    private func beginDrag(_ entry: TaskbarEntryModel) {
        dragging = entry.orderingKey
        over = nil
    }

    private func retarget(_ entry: TaskbarEntryModel, isTargeted: Bool) {
        guard isTargeted else {
            if over == entry.orderingKey { over = nil }
            return
        }
        guard entry.orderingKey != dragging else { return }
        over = entry.orderingKey
    }

    private func commit(_ dropped: String, on entry: TaskbarEntryModel) {
        onDropPin(dropped, entry)
        dragging = nil
        over = nil
    }
}
