import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

package struct TaskbarItems: View {
    package let viewModel: TaskbarViewModel
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onOpenStart: () -> Void
    package let onOpenSettings: () -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onCloseWindow: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onDropPin: (String, TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void
    package let battery: BatteryState
    package let onOpenBattery: () -> Void
    package let onOpenNotifications: () -> Void
    package let onOpenControlCentre: () -> Void
    package let trash: TrashMonitor
    package let timer: TimerMonitor
    package let totals: TotalsMonitor
    package let onOpenTimer: () -> Void

    package var body: some View {
        KbAxisStack(isVertical: viewModel.preset.edge.isVertical, spacing: viewModel.preset.entrySpacing) {
            if viewModel.preset.startButton != .hidden {
                TaskbarStartButton(
                    mark: viewModel.preset.startMark,
                    iconSize: viewModel.preset.iconSize,
                    cornerRadius: viewModel.preset.entryCornerRadius,
                    onOpen: onOpenStart,
                    onOpenSettings: onOpenSettings
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
            if viewModel.preset.showsTrash {
                TaskbarSeparator(isVertical: viewModel.preset.edge.isVertical)
                TaskbarTrash(monitor: trash)
            }
            TaskbarSeparator(isVertical: viewModel.preset.edge.isVertical)
            if viewModel.preset.showsBattery, battery.isPresent {
                TaskbarBattery(state: battery, onOpen: onOpenBattery)
            }
            if viewModel.preset.showsControlCentre {
                TaskbarControlCentreButton(onOpen: onOpenControlCentre)
            }
            if viewModel.preset.showsClock {
                TaskbarClock(onOpen: onOpenNotifications)
            }
            if viewModel.preset.showsTracking {
                TaskbarTracking(timer: timer, totals: totals, onOpenTimer: onOpenTimer)
            }
        }
    }
}
