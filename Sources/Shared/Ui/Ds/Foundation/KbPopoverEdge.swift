import SwiftUI

/** The popover's rim, drawn outside the glass so the material does not blur it. */
struct KbPopoverEdge: View {
    let arrowX: CGFloat

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

    private var outline: KbPopoverShape {
        KbPopoverShape(arrowX: arrowX)
    }
}
