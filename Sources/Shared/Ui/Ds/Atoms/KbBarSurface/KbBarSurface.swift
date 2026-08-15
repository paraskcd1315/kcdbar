import SwiftUI

struct KbBarSurface<Content: View>: View {
    let material: BarMaterial
    let edge: BarEdge
    let attachment: BarAttachment
    let cornerRadius: CGFloat
    @ViewBuilder let content: () -> Content

    var body: some View {
        KbBarFill(
            material: material,
            shape: KbBarShape.shape(edge: edge, attachment: attachment, cornerRadius: cornerRadius),
            content: content
        )
        .overlay {
            KbBarEdgeOutline(edge: edge, attachment: attachment, cornerRadius: cornerRadius)
                .stroke(
                    KbBarSurfaceStyle.edgeGradient(edge: edge),
                    lineWidth: KbBarSurfaceMetrics.edgeWidth
                )
                .allowsHitTesting(false)
        }
    }
}
