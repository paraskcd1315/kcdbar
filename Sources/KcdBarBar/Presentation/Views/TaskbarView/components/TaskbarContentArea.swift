import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

package struct TaskbarContentArea: View {
    package let viewModel: TaskbarViewModel
    package let onActivate: (TaskbarEntryModel) -> Void
    package let onRequestAccessibility: () -> Void
    package let onOpenStart: () -> Void
    package let onTogglePin: (TaskbarEntryModel) -> Void
    package let onQuit: (TaskbarEntryModel) -> Void
    package let onDropPin: (String, TaskbarEntryModel) -> Void
    package let onMiddleClick: (TaskbarEntryModel) -> Void
    package let battery: BatteryState
    package let onOpenBattery: () -> Void
    package let onOpenNotifications: () -> Void
    package let onOpenControlCentre: () -> Void

    package var body: some View {
        Group {
            if let notice = viewModel.notice {
                TaskbarNoticeView(notice: notice, onAct: onRequestAccessibility)
            } else {
                TaskbarItems(
                    viewModel: viewModel,
                    onActivate: onActivate,
                    onOpenStart: onOpenStart,
                    onTogglePin: onTogglePin,
                    onQuit: onQuit,
                    onDropPin: onDropPin,
                    onMiddleClick: onMiddleClick,
                    battery: battery,
                    onOpenBattery: onOpenBattery,
                    onOpenNotifications: onOpenNotifications,
                    onOpenControlCentre: onOpenControlCentre,
                )
            }
        }
        .padding(viewModel.preset.contentPadding)
        .animation(KbMotion.standard, value: viewModel.entries)
    }
}
