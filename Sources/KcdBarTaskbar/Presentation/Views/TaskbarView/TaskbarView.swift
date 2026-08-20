import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

package struct TaskbarView: View {
    package let viewModel: TaskbarViewModel
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
    package let isShowingDesktop: Bool
    package let onToggleDesktop: () -> Void
    package let onBarFrameChange: (CGRect) -> Void

    @State private var hasAppeared = false
    @State private var hover = TaskbarHoverState()

    package var body: some View {
        KbBarSurface(
            material: viewModel.preset.material,
            edge: viewModel.preset.edge,
            attachment: viewModel.preset.attachment,
            cornerRadius: viewModel.preset.cornerRadius
        ) {
            TaskbarBody(
                viewModel: viewModel,
                isShowingDesktop: isShowingDesktop,
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

                onOpenTimer: onOpenTimer,
                onToggleDesktop: onToggleDesktop
            )
        }
        .frame(
            width: viewModel.preset.edge.isVertical ? viewModel.preset.thickness : nil,
            height: viewModel.preset.edge.isVertical ? nil : viewModel.preset.thickness
        )
        .padding(TaskbarBarLayout.outsetPadding(attachment: viewModel.preset.attachment))
        .offset(x: appearOffset.width, y: appearOffset.height)
        .opacity(hasAppeared ? 1 : 0)
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .named(TaskbarBarLayout.coordinateSpace))
        } action: { onBarFrameChange($0) }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: TaskbarBarLayout.contentAlignment(preset: viewModel.preset)
        )
        .coordinateSpace(.named(TaskbarBarLayout.coordinateSpace))
        .environment(\.taskbarHover, hover)
        .overlay { TaskbarTooltipLayer(hover: hover, edge: viewModel.preset.edge) }
        .onAppear {
            withAnimation(KbMotion.slow) { hasAppeared = true }
        }
    }

    private var appearOffset: CGSize {
        guard !hasAppeared else { return .zero }

        return TaskbarBarLayout.appearOffset(
            edge: viewModel.preset.edge,
            thickness: viewModel.preset.thickness
        )
    }
}
