import SwiftUI

package struct KbTileEdge: View {
    package let cornerRadius: CGFloat

    package var body: some View {
        ZStack {
            shape
                .stroke(KbColors.glassEdgeBright, lineWidth: KbEdgeMetrics.width)
                .blendMode(.plusLighter)
            shape
                .stroke(KbColors.glassEdgeShade, lineWidth: KbEdgeMetrics.width)
                .blendMode(.plusDarker)
        }
        .allowsHitTesting(false)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
}
