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
        .frame(
            maxWidth: viewModel.preset.widthMode == .fullEdge ? .infinity : nil,
            maxHeight: viewModel.preset.edge.isVertical ? .infinity : nil
        )
    }

    private var surfaceShape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: viewModel.preset.cornerRadius))
    }

    private var outsetPadding: CGFloat {
        viewModel.preset.widthMode == .island ? TaskbarMetrics.islandOutset : 0
    }

    private var contentAlignment: Alignment {
        switch viewModel.preset.alignment {
        case .leading: viewModel.preset.edge.isVertical ? .top : .leading
        case .centered: .center
        case .trailing: viewModel.preset.edge.isVertical ? .bottom : .trailing
        }
    }
}
