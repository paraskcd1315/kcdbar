import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

package struct TaskbarItems: View {
    package let viewModel: TaskbarViewModel
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onOpenStart: () -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onDropPin: (String, TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void
    package let battery: BatteryState
    package let onOpenBattery: () -> Void
    package let onOpenNotifications: () -> Void
    package let onOpenControlCentre: () -> Void
    package let trash: TrashMonitor

    package var body: some View {
        KbAxisStack(isVertical: viewModel.preset.edge.isVertical, spacing: viewModel.preset.entrySpacing) {
            if viewModel.preset.startButton != .hidden {
                TaskbarStartButton(onOpen: onOpenStart)
            }
            TaskbarEntryStrip(
                entries: viewModel.entries,
                preset: viewModel.preset,
                onActivate: onActivate,
                onTogglePin: onTogglePin,
                onQuit: onQuit,
                onDropPin: onDropPin,
                onMiddleClick: onMiddleClick
            )
            if viewModel.preset.showsStatusArea {
                if battery.isPresent {
                    TaskbarBattery(state: battery, onOpen: onOpenBattery)
                }
                TaskbarControlCentreButton(onOpen: onOpenControlCentre)
                TaskbarClock(onOpen: onOpenNotifications)
            }
            TaskbarTrash(monitor: trash)
        }
    }
}
