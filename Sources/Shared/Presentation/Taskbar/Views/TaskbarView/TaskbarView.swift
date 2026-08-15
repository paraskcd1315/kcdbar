import SwiftUI

struct TaskbarView: View {
    let viewModel: TaskbarViewModel
    let onActivate: (TaskbarEntryModel) -> Void
    let onRequestAccessibility: () -> Void
    let onOpenStart: () -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void
    let onMiddleClick: (TaskbarEntryModel) -> Void
    let battery: BatteryState
    let onOpenBattery: () -> Void
    let onOpenNotifications: () -> Void
    let onOpenControlCentre: () -> Void
    let isShowingDesktop: Bool
    let onToggleDesktop: () -> Void
    let onBarFrameChange: (CGRect) -> Void

    @State private var hasAppeared = false

    var body: some View {
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
                onTogglePin: onTogglePin,
                onDropPin: onDropPin,
                onMiddleClick: onMiddleClick,
                battery: battery,
                onOpenBattery: onOpenBattery,
                onOpenNotifications: onOpenNotifications,
                onOpenControlCentre: onOpenControlCentre,
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
