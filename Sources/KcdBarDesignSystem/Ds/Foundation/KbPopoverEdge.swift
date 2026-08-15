import SwiftUI

/** The popover's rim, drawn outside the glass so the material does not blur it. */
package struct KbPopoverEdge: View {
    package let arrowX: CGFloat?

    package init(arrowX: CGFloat?) {
        self.arrowX = arrowX
    }

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

    private var outline: KbPopoverShape {
        KbPopoverShape(arrowX: arrowX)
    }
}
