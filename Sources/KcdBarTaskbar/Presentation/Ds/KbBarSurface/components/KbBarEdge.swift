import KcdBarDesignSystem
import SwiftUI

/** The bar's rim, drawn outside the glass so it is not blurred by the material. */
package struct KbBarEdge: View {
    package let edge: BarEdge
    package let attachment: BarAttachment
    package let cornerRadius: CGFloat

    package var body: some View {
        ZStack {
            outline
                .stroke(KbColors.glassEdgeBright, lineWidth: KbEdgeMetrics.width)
                .blendMode(.plusLighter)
            outline
                .stroke(KbColors.glassEdgeShade, lineWidth: KbEdgeMetrics.width)
                .blendMode(.plusDarker)
        }
        .allowsHitTesting(false)
    }

    private var outline: KbBarEdgeOutline {
        KbBarEdgeOutline(edge: edge, attachment: attachment, cornerRadius: cornerRadius)
    }
}
