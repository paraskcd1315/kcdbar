import SwiftUI

/** The bar's rim, drawn outside the glass so it is not blurred by the material. */
struct KbBarEdge: View {
    let edge: BarEdge
    let attachment: BarAttachment
    let cornerRadius: CGFloat

    var body: some View {
        ZStack {
            outline
                .stroke(KbColors.glassEdgeBright, lineWidth: KbBarSurfaceMetrics.edgeWidth)
                .blendMode(.plusLighter)
            outline
                .stroke(KbColors.glassEdgeShade, lineWidth: KbBarSurfaceMetrics.edgeWidth)
                .blendMode(.plusDarker)
        }
        .allowsHitTesting(false)
    }

    private var outline: KbBarEdgeOutline {
        KbBarEdgeOutline(edge: edge, attachment: attachment, cornerRadius: cornerRadius)
    }
}
