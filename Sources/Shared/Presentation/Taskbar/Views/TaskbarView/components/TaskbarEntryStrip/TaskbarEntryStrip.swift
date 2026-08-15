import SwiftUI

struct TaskbarEntryStrip: View {
    let entries: [TaskbarEntryModel]
    let preset: BarPreset
    let onActivate: (TaskbarEntryModel) -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void
    let onMiddleClick: (TaskbarEntryModel) -> Void

    var body: some View {
        KbAxisStack(isVertical: preset.edge.isVertical, spacing: preset.entrySpacing) {
            ForEach(entries) { entry in
                TaskbarEntryView(
                    entry: entry,
                    preset: preset,
                    onActivate: { onActivate(entry) },
                    onTogglePin: { onTogglePin(entry) },
                    onDropPin: { dropped in onDropPin(dropped, entry) },
                    onMiddleClick: { onMiddleClick(entry) }
                )
                .transition(TaskbarStripLayout.insertion)
            }
        }
        .animation(KbMotion.standard, value: entries)
        .frame(
            maxWidth: expandsAlongBar && !preset.edge.isVertical ? .infinity : nil,
            maxHeight: expandsAlongBar && preset.edge.isVertical ? .infinity : nil,
            alignment: TaskbarStripLayout.alignment(preset: preset)
        )
    }

    private var expandsAlongBar: Bool {
        TaskbarStripLayout.expandsAlongBar(preset: preset)
    }
}
