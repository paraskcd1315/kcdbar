import SwiftUI

struct KbTileEdge: View {
    let cornerRadius: CGFloat

    var body: some View {
        ZStack {
            shape
                .stroke(KbColors.glassEdgeBright, lineWidth: KbTileMetrics.edgeWidth)
                .blendMode(.plusLighter)
            shape
                .stroke(KbColors.glassEdgeShade, lineWidth: KbTileMetrics.edgeWidth)
                .blendMode(.plusDarker)
        }
        .allowsHitTesting(false)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
}
