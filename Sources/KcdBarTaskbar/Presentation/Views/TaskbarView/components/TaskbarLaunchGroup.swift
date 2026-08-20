import KcdBarDesignSystem
import SwiftUI

package struct TaskbarLaunchGroup: View {
    package let viewModel: TaskbarViewModel
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onOpenStart: () -> Void
    package let onOpenSettings: () -> Void
    package let onOpenAbout: () -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onCloseWindow: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onDropPin: (String, TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void

    package var body: some View {
        KbAxisStack(isVertical: viewModel.preset.edge.isVertical, spacing: viewModel.preset.entrySpacing) {
            if viewModel.preset.startButton == .centered {
                TaskbarStartButton(
                    mark: viewModel.preset.startMark,
                    iconSize: BarEntryMetrics.iconSize(for: viewModel.preset),
                    cornerRadius: viewModel.preset.entryCornerRadius,
                    isVertical: viewModel.preset.edge.isVertical,
                    side: BarEntryMetrics.itemSide(for: viewModel.preset),
                    onOpen: onOpenStart,
                    onOpenSettings: onOpenSettings,
                    onOpenAbout: onOpenAbout
                )
            }
            TaskbarEntryStrip(
                entries: viewModel.entries,
                preset: viewModel.preset,
                onActivate: onActivate,
                onTogglePin: onTogglePin,
                onCloseWindow: onCloseWindow,
                onQuit: onQuit,
                onDropPin: onDropPin,
                onMiddleClick: onMiddleClick
            )
        }
        .frame(
            maxWidth: TaskbarStripLayout.expandsAlongBar(preset: viewModel.preset)
                && !viewModel.preset.edge.isVertical ? .infinity : nil,
            maxHeight: TaskbarStripLayout.expandsAlongBar(preset: viewModel.preset)
                && viewModel.preset.edge.isVertical ? .infinity : nil,
            alignment: TaskbarStripLayout.alignment(preset: viewModel.preset)
        )
    }
}
