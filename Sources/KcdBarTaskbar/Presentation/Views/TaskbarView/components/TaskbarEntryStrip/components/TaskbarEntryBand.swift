import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryBand: View {
    package let group: TaskbarEntryGroup
    package let preset: BarPreset
    package let isDragging: Bool
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onCloseWindow: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void

    package var body: some View {
        KbAxisStack(isVertical: preset.edge.isVertical, spacing: TaskbarMetrics.bandSpacing) {
            ForEach(group.entries) { entry in
                TaskbarEntryView(
                    entry: entry,
                    preset: preset,
                    isDragging: isDragging,
                    onActivate: { onActivate(entry) },
                    onTogglePin: { onTogglePin(entry) },
                    onCloseWindow: { onCloseWindow(entry) },
                    onQuit: { onQuit(entry) },
                    onMiddleClick: { onMiddleClick(entry) }
                )
            }
        }
        .padding(alongBar, group.isBanded ? TaskbarMetrics.bandPadding : 0)
        .background {
            if group.isBanded {
                bandShape.fill(KbColors.bandFill)
            }
        }
    }

    private var alongBar: Edge.Set {
        preset.edge.isVertical ? .vertical : .horizontal
    }

    private var bandShape: AnyShape {
        KbBarShape.shape(
            edge: preset.edge,
            attachment: preset.attachment,
            cornerRadius: preset.entryCornerRadius
        )
    }
}
