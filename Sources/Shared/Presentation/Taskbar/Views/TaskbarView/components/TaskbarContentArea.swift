import SwiftUI

struct TaskbarContentArea: View {
    let viewModel: TaskbarViewModel
    let onActivate: (TaskbarEntryModel) -> Void
    let onRequestAccessibility: () -> Void
    let onOpenStart: () -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void
    let onMiddleClick: (TaskbarEntryModel) -> Void
    let onPressTrayItem: (TrayItemModel) -> Void

    var body: some View {
        Group {
            if let notice = viewModel.notice {
                TaskbarNoticeView(notice: notice, onAct: onRequestAccessibility)
            } else {
                TaskbarItems(
                    viewModel: viewModel,
                    onActivate: onActivate,
                    onOpenStart: onOpenStart,
                    onTogglePin: onTogglePin,
                    onDropPin: onDropPin,
                    onMiddleClick: onMiddleClick,
                    onPressTrayItem: onPressTrayItem
                )
            }
        }
        .padding(viewModel.preset.contentPadding)
        .animation(KbMotion.standard, value: viewModel.entries)
    }
}
