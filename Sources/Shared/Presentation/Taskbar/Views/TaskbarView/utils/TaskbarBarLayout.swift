import SwiftUI

enum TaskbarBarLayout {
    static let coordinateSpace = "kb.bar.panel"

    static func appearOffset(edge: BarEdge, thickness: CGFloat) -> CGSize {
        switch edge {
        case .bottom: CGSize(width: 0, height: thickness)
        case .top: CGSize(width: 0, height: -thickness)
        case .leading: CGSize(width: -thickness, height: 0)
        case .trailing: CGSize(width: thickness, height: 0)
        }
    }

    static func outsetPadding(attachment: BarAttachment) -> CGFloat {
        attachment == .floating ? TaskbarMetrics.islandOutset : 0
    }

    static func fillsCrossAxis(_ axis: Axis.Set, preset: BarPreset) -> Bool {
        let alongBar: Axis.Set = preset.edge.isVertical ? .vertical : .horizontal
        guard axis == alongBar else { return true }
        return preset.widthMode == .fullEdge
    }

    static func contentAlignment(preset: BarPreset) -> Alignment {
        preset.edge.isVertical
            ? Alignment(
                horizontal: crossAxisHorizontal(preset: preset),
                vertical: alongAxisVertical(alignment: preset.alignment)
            )
            : Alignment(
                horizontal: alongAxisHorizontal(alignment: preset.alignment),
                vertical: crossAxisVertical(preset: preset)
            )
    }

    static func alongAxisHorizontal(alignment: BarAlignment) -> HorizontalAlignment {
        switch alignment {
        case .leading: .leading
        case .centered: .center
        case .trailing: .trailing
        }
    }

    static func alongAxisVertical(alignment: BarAlignment) -> VerticalAlignment {
        switch alignment {
        case .leading: .top
        case .centered: .center
        case .trailing: .bottom
        }
    }

    static func crossAxisVertical(preset: BarPreset) -> VerticalAlignment {
        guard preset.attachment == .edgeAttached else { return .center }
        return preset.edge == .top ? .top : .bottom
    }

    static func crossAxisHorizontal(preset: BarPreset) -> HorizontalAlignment {
        guard preset.attachment == .edgeAttached else { return .center }
        return preset.edge == .leading ? .leading : .trailing
    }
}
