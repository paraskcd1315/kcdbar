import SwiftUI

struct TaskbarView: View {
    let viewModel: TaskbarViewModel
    let onActivate: (TaskbarEntryModel) -> Void
    let onRequestAccessibility: () -> Void

    var body: some View {
        GlassEffectContainer {
            KbBarSurface(material: viewModel.preset.material, shape: surfaceShape) {
                content
            }
        }
        .padding(outsetPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: contentAlignment)
    }

    @ViewBuilder
    private var content: some View {
        Group {
            if let notice = viewModel.notice {
                TaskbarNoticeView(notice: notice, onAct: onRequestAccessibility)
            } else {
                TaskbarEntryStrip(
                    entries: viewModel.entries,
                    preset: viewModel.preset,
                    onActivate: onActivate
                )
            }
        }
        .padding(viewModel.preset.contentPadding)
        .animation(KbMotion.standard, value: viewModel.entries)
        .frame(
            maxWidth: fillsCrossAxis(.horizontal) ? .infinity : nil,
            maxHeight: fillsCrossAxis(.vertical) ? .infinity : nil
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
