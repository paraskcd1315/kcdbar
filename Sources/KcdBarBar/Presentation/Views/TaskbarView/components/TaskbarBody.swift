import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

package struct TaskbarBody: View {
    package let viewModel: TaskbarViewModel
    package let isShowingDesktop: Bool
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onRequestAccessibility: () -> Void
    package let onOpenStart: () -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onDropPin: (String, TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void
    package let battery: BatteryState
    package let onOpenBattery: () -> Void
    package let onOpenNotifications: () -> Void
    package let onOpenControlCentre: () -> Void
    package let onToggleDesktop: () -> Void

    package var body: some View {
        KbAxisStack(isVertical: viewModel.preset.edge.isVertical, spacing: 0) {
            TaskbarContentArea(
                viewModel: viewModel,
                onActivate: onActivate,
                onRequestAccessibility: onRequestAccessibility,
                onOpenStart: onOpenStart,
                onTogglePin: onTogglePin,
                onDropPin: onDropPin,
                onMiddleClick: onMiddleClick,
                battery: battery,
                onOpenBattery: onOpenBattery,
                onOpenNotifications: onOpenNotifications,
                onOpenControlCentre: onOpenControlCentre,
            )
            if showsDesktopCap {
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
