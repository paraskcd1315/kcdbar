import SwiftUI

package struct KbBarSurface<Content: View>: View {
    package let material: BarMaterial
    package let edge: BarEdge
    package let attachment: BarAttachment
    package let cornerRadius: CGFloat
    @ViewBuilder package let content: () -> Content

    package var body: some View {
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
