import SwiftUI

enum KbBarSurfaceStyle {
    static func edgeGradient(edge: BarEdge) -> LinearGradient {
        let ends = gradientEnds(edge: edge)

        return LinearGradient(
            colors: [KbColors.glassEdgeBright, KbColors.glassEdgeDim],
            startPoint: ends.bright,
            endPoint: ends.dim
        )
    }

    private static func gradientEnds(edge: BarEdge) -> (bright: UnitPoint, dim: UnitPoint) {
        switch edge {
        case .bottom: (.top, .bottom)
        case .top: (.bottom, .top)
        case .leading: (.trailing, .leading)
        case .trailing: (.leading, .trailing)
        }
    }
}
