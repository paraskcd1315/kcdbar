import SwiftUI

struct TaskbarEntryStrip: View {
    let entries: [TaskbarEntryModel]
    let preset: BarPreset
    let onActivate: (TaskbarEntryModel) -> Void

    var body: some View {
        layout {
            ForEach(entries) { entry in
                TaskbarEntryView(entry: entry, preset: preset) { onActivate(entry) }
                    .transition(entryTransition)
            }
        }
        .animation(KbMotion.standard, value: entries)
        .frame(
            maxWidth: expandsAlongBar && !preset.edge.isVertical ? .infinity : nil,
            maxHeight: expandsAlongBar && preset.edge.isVertical ? .infinity : nil,
            alignment: stackAlignment
        )
    }

    private var expandsAlongBar: Bool {
        preset.widthMode == .fullEdge
    }

    private var entryTransition: AnyTransition {
        .scale(scale: TaskbarMetrics.insertionScale, anchor: .center)
            .combined(with: .opacity)
    }

    @ViewBuilder
    private func layout<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        if preset.edge.isVertical {
            VStack(spacing: preset.entrySpacing, content: content)
        } else {
            HStack(spacing: preset.entrySpacing, content: content)
        }
    }

    private var stackAlignment: Alignment {
        switch preset.alignment {
        case .leading: preset.edge.isVertical ? .top : .leading
        case .centered: .center
        case .trailing: preset.edge.isVertical ? .bottom : .trailing
        }
    }
}
