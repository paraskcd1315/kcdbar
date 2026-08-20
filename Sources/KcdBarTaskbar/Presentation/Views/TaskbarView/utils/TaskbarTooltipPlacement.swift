import SwiftUI

package enum TaskbarTooltipPlacement {
    package static func x(over item: CGRect, tooltip: CGSize, panel: CGSize, edge: BarEdge) -> CGFloat {
        guard !edge.isVertical else {
            return edge == .leading
                ? item.maxX + TaskbarMetrics.tooltipGap + tooltip.width / 2
                : item.minX - TaskbarMetrics.tooltipGap - tooltip.width / 2
        }
        return clamped(item.midX, half: tooltip.width / 2, limit: panel.width)
    }

    package static func y(over item: CGRect, tooltip: CGSize, panel: CGSize, edge: BarEdge) -> CGFloat {
        guard edge.isVertical else {
            return edge == .top
                ? item.maxY + TaskbarMetrics.tooltipGap + tooltip.height / 2
                : item.minY - TaskbarMetrics.tooltipGap - tooltip.height / 2
        }
        return clamped(item.midY, half: tooltip.height / 2, limit: panel.height)
    }

    package static func arrival(for edge: BarEdge) -> Edge {
        switch edge {
        case .bottom: .bottom
        case .top: .top
        case .leading: .leading
        case .trailing: .trailing
        }
    }

    private static func clamped(_ centre: CGFloat, half: CGFloat, limit: CGFloat) -> CGFloat {
        guard limit > half * 2 else { return limit / 2 }

        return min(max(centre, half + TaskbarMetrics.tooltipEdgeInset), limit - half - TaskbarMetrics.tooltipEdgeInset)
    }
}
