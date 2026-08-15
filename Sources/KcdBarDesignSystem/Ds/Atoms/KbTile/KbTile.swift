import SwiftUI

/** A floating glass tile. */
struct KbTile<Content: View>: View {
    var cornerRadius: CGFloat = KbRadii.xl
    var padding: CGFloat = KbSpacing.s4
    @ViewBuilder let content: Content

    var body: some View {
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
