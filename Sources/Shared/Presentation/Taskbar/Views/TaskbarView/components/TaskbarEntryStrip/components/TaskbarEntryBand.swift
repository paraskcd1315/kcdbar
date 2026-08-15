import SwiftUI

struct TaskbarEntryBand: View {
    let group: TaskbarEntryGroup
    let preset: BarPreset
    let isDragging: Bool
    let onActivate: (TaskbarEntryModel) -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onMiddleClick: (TaskbarEntryModel) -> Void

    var body: some View {
        KbAxisStack(isVertical: preset.edge.isVertical, spacing: TaskbarMetrics.bandSpacing) {
            ForEach(group.entries) { entry in
                TaskbarEntryView(
                    entry: entry,
                    preset: preset,
                    isDragging: isDragging,
                    onActivate: { onActivate(entry) },
                    onTogglePin: { onTogglePin(entry) },
                    onMiddleClick: { onMiddleClick(entry) }
                )
            }
        }
        .padding(group.isBanded ? TaskbarMetrics.bandPadding : 0)
        .glassEffect(group.isBanded ? .regular : .identity, in: bandShape)
    }

    private var bandShape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.lg))
    }
}
