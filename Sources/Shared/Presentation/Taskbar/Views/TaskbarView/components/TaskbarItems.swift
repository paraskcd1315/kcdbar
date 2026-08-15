import SwiftUI

struct TaskbarItems: View {
    let viewModel: TaskbarViewModel
    let onActivate: (TaskbarEntryModel) -> Void
    let onOpenStart: () -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void
    let onMiddleClick: (TaskbarEntryModel) -> Void
    let onPressTrayItem: (TrayItemModel) -> Void

    var body: some View {
        KbAxisStack(isVertical: viewModel.preset.edge.isVertical, spacing: viewModel.preset.entrySpacing) {
            if viewModel.preset.startButton != .hidden {
                TaskbarStartButton(onOpen: onOpenStart)
            }
            TaskbarEntryStrip(
                entries: viewModel.entries,
                preset: viewModel.preset,
                onActivate: onActivate,
                onTogglePin: onTogglePin,
                onDropPin: onDropPin,
                onMiddleClick: onMiddleClick
            )
            if viewModel.preset.showsStatusArea {
                TaskbarTray(
                    items: viewModel.trayItems,
                    isVertical: viewModel.preset.edge.isVertical,
                    onPress: onPressTrayItem
                )
                TaskbarClock()
            }
        }
    }
}
