import SwiftUI

struct KbBarSurface<Content: View>: View {
    let material: BarMaterial
    let edge: BarEdge
    let attachment: BarAttachment
    let cornerRadius: CGFloat
    @ViewBuilder let content: () -> Content

    var body: some View {
        GlassEffectContainer {
            KbBarFill(
                material: material,
                shape: KbBarShape.shape(edge: edge, attachment: attachment, cornerRadius: cornerRadius),
                content: content
            )
        }
        .overlay {
            KbBarEdge(edge: edge, attachment: attachment, cornerRadius: cornerRadius)
        }
    }
}
