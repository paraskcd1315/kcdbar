import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

package struct TaskbarBody: View {
    package let viewModel: TaskbarViewModel
    package let isShowingDesktop: Bool
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onRequestAccessibility: () -> Void
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
    package let onToggleDesktop: () -> Void

    package var body: some View {
        KbAxisStack(isVertical: viewModel.preset.edge.isVertical, spacing: 0) {
            TaskbarContentArea(
                viewModel: viewModel,
                onActivate: onActivate,
                onRequestAccessibility: onRequestAccessibility,
                onOpenStart: onOpenStart,
                onOpenSettings: onOpenSettings,
                onTogglePin: onTogglePin,
                onCloseWindow: onCloseWindow,
                onQuit: onQuit,
                onDropPin: onDropPin,
                onMiddleClick: onMiddleClick,
                battery: battery,
                onOpenBattery: onOpenBattery,
                onOpenNotifications: onOpenNotifications,
                onOpenControlCentre: onOpenControlCentre,
                trash: trash,
                timer: timer,
                totals: totals,
                onOpenTimer: onOpenTimer
            )
            if showsDesktopCap {
                TaskbarSeparator(isVertical: viewModel.preset.edge.isVertical)
                TaskbarDesktopCap(
                    preset: viewModel.preset,
                    isShowingDesktop: isShowingDesktop,
                    onToggle: onToggleDesktop
                )
            }
        }
        .frame(
            maxWidth: TaskbarBarLayout.fillsCrossAxis(.horizontal, preset: viewModel.preset)
                ? .infinity
                : nil,
            maxHeight: TaskbarBarLayout.fillsCrossAxis(.vertical, preset: viewModel.preset)
                ? .infinity
                : nil
        )
    }

    private var showsDesktopCap: Bool {
        viewModel.preset.showsDesktopButton && viewModel.notice == nil
    }
}
