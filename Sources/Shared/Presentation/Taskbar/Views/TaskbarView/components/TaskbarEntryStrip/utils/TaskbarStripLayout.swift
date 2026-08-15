import SwiftUI

enum TaskbarStripLayout {
    static func expandsAlongBar(preset: BarPreset) -> Bool {
        preset.widthMode == .fullEdge
    }

    static func alignment(preset: BarPreset) -> Alignment {
        switch preset.alignment {
        case .leading: preset.edge.isVertical ? .top : .leading
        case .centered: .center
        case .trailing: preset.edge.isVertical ? .bottom : .trailing
        }
    }

    static var insertion: AnyTransition {
        .scale(scale: TaskbarMetrics.insertionScale, anchor: .center).combined(with: .opacity)
    }
}
