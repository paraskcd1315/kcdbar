import SwiftUI

package enum TaskbarStripLayout {
    package static let coordinateSpace = "taskbar.strip"

    package static func expandsAlongBar(preset: BarPreset) -> Bool {
        preset.widthMode == .fullEdge
    }

    package static func alignment(preset: BarPreset) -> Alignment {
        switch preset.alignment {
        case .leading: preset.edge.isVertical ? .top : .leading
        case .centered: .center
        case .trailing: preset.edge.isVertical ? .bottom : .trailing
        }
    }

    package static var insertion: AnyTransition {
        .scale(scale: TaskbarMetrics.insertionScale, anchor: .center).combined(with: .opacity)
    }
}
