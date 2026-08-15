import SwiftUI

/** A floating glass tile. */
package struct KbTile<Content: View>: View {
    package var cornerRadius: CGFloat = KbRadii.xl
    package var padding: CGFloat = KbSpacing.s4
    @ViewBuilder package let content: Content

    package init(
        cornerRadius: CGFloat = KbRadii.xl,
        padding: CGFloat = KbSpacing.s4,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    package var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular.interactive(), in: shape)
            .overlay(KbTileEdge(cornerRadius: cornerRadius))
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
}
