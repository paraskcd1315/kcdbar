import SwiftUI

struct TaskbarBody: View {
    let viewModel: TaskbarViewModel
    let isShowingDesktop: Bool
    let onActivate: (TaskbarEntryModel) -> Void
    let onRequestAccessibility: () -> Void
    let onOpenStart: () -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void
    let onMiddleClick: (TaskbarEntryModel) -> Void
    let onToggleDesktop: () -> Void

    var body: some View {
        KbAxisStack(isVertical: viewModel.preset.edge.isVertical, spacing: 0) {
            TaskbarContentArea(
                viewModel: viewModel,
                onActivate: onActivate,
                onRequestAccessibility: onRequestAccessibility,
                onOpenStart: onOpenStart,
                onTogglePin: onTogglePin,
                onDropPin: onDropPin,
                onMiddleClick: onMiddleClick
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
