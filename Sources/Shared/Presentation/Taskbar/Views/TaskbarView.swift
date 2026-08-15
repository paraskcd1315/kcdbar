import SwiftUI

struct TaskbarView: View {
    let viewModel: TaskbarViewModel
    let onActivate: (TaskbarEntryModel) -> Void
    let onRequestAccessibility: () -> Void
    let onOpenStart: () -> Void
    let onTogglePin: (TaskbarEntryModel) -> Void
    let onDropPin: (String, TaskbarEntryModel) -> Void
    let isShowingDesktop: Bool
    let onToggleDesktop: () -> Void

    @State private var hasAppeared = false

    var body: some View {
        GlassEffectContainer {
            KbBarSurface(material: viewModel.preset.material, shape: surfaceShape) {
                content
            }
        }
        .frame(
            width: viewModel.preset.edge.isVertical ? viewModel.preset.thickness : nil,
            height: viewModel.preset.edge.isVertical ? nil : viewModel.preset.thickness
        )
        .padding(outsetPadding)
        .offset(x: appearOffset.width, y: appearOffset.height)
        .opacity(hasAppeared ? 1 : 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: contentAlignment)
        .onAppear {
            withAnimation(KbMotion.slow) { hasAppeared = true }
        }
    }

    private var appearOffset: CGSize {
        guard !hasAppeared else { return .zero }
        let distance = viewModel.preset.thickness
        switch viewModel.preset.edge {
        case .bottom: return CGSize(width: 0, height: distance)
        case .top: return CGSize(width: 0, height: -distance)
        case .leading: return CGSize(width: -distance, height: 0)
        case .trailing: return CGSize(width: distance, height: 0)
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.preset.edge.isVertical {
            VStack(spacing: 0) {
                paddedContent
                desktopButton
            }
            .frame(
                maxWidth: fillsCrossAxis(.horizontal) ? .infinity : nil,
                maxHeight: fillsCrossAxis(.vertical) ? .infinity : nil
            )
        } else {
            HStack(spacing: 0) {
                paddedContent
                desktopButton
            }
            .frame(
                maxWidth: fillsCrossAxis(.horizontal) ? .infinity : nil,
                maxHeight: fillsCrossAxis(.vertical) ? .infinity : nil
            )
        }
    }

    @ViewBuilder
    private var paddedContent: some View {
        Group {
            if let notice = viewModel.notice {
                TaskbarNoticeView(notice: notice, onAct: onRequestAccessibility)
            } else {
                barContent
            }
        }
        .padding(viewModel.preset.contentPadding)
        .animation(KbMotion.standard, value: viewModel.entries)
    }

    @ViewBuilder
    private var desktopButton: some View {
        if viewModel.preset.showsDesktopButton, viewModel.notice == nil {
            TaskbarShowDesktopButton(
                isShowingDesktop: isShowingDesktop,
                onToggle: onToggleDesktop
            )
        }
    }

    @ViewBuilder
    private var barContent: some View {
        if viewModel.preset.edge.isVertical {
            VStack(spacing: viewModel.preset.entrySpacing) {
                if viewModel.preset.startButton != .hidden {
                    TaskbarStartButton(onOpen: onOpenStart)
                }
                entryStrip
                if viewModel.preset.showsStatusArea {
                    TaskbarClock()
                }
            }
        } else {
            HStack(spacing: viewModel.preset.entrySpacing) {
                if viewModel.preset.startButton != .hidden {
                    TaskbarStartButton(onOpen: onOpenStart)
                }
                entryStrip
                if viewModel.preset.showsStatusArea {
                    TaskbarClock()
                }
            }
        }
    }

    private var entryStrip: some View {
        TaskbarEntryStrip(
            entries: viewModel.entries,
            preset: viewModel.preset,
            onActivate: onActivate,
            onTogglePin: onTogglePin,
            onDropPin: onDropPin
        )
    }

    private func fillsCrossAxis(_ axis: Axis.Set) -> Bool {
        let alongBar: Axis.Set = viewModel.preset.edge.isVertical ? .vertical : .horizontal
        guard axis == alongBar else { return true }
        return viewModel.preset.widthMode == .fullEdge
    }

    private var surfaceShape: AnyShape {
        KbBarShape.shape(
            edge: viewModel.preset.edge,
            attachment: viewModel.preset.attachment,
            cornerRadius: viewModel.preset.cornerRadius
        )
    }

    private var outsetPadding: CGFloat {
        viewModel.preset.attachment == .floating ? TaskbarMetrics.islandOutset : 0
    }

    private var contentAlignment: Alignment {
        viewModel.preset.edge.isVertical
            ? Alignment(horizontal: crossAxisHorizontal, vertical: alongAxisVertical)
            : Alignment(horizontal: alongAxisHorizontal, vertical: crossAxisVertical)
    }

    private var alongAxisHorizontal: HorizontalAlignment {
        switch viewModel.preset.alignment {
        case .leading: .leading
        case .centered: .center
        case .trailing: .trailing
        }
    }

    private var alongAxisVertical: VerticalAlignment {
        switch viewModel.preset.alignment {
        case .leading: .top
        case .centered: .center
        case .trailing: .bottom
        }
    }

    private var crossAxisVertical: VerticalAlignment {
        guard viewModel.preset.attachment == .edgeAttached else { return .center }
        return viewModel.preset.edge == .top ? .top : .bottom
    }

    private var crossAxisHorizontal: HorizontalAlignment {
        guard viewModel.preset.attachment == .edgeAttached else { return .center }
        return viewModel.preset.edge == .leading ? .leading : .trailing
    }
}
