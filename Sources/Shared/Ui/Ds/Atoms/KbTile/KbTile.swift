import SwiftUI

/** A rounded plate inside a glass panel. */
struct KbTile<Content: View>: View {
    var cornerRadius: CGFloat = KbRadii.xl
    var padding: CGFloat = KbSpacing.s3
    var fill: Color = KbColors.tileFill
    var edge: Color = KbColors.tileEdge
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(shape.fill(fill))
            .overlay(shape.stroke(edge, lineWidth: KbTileMetrics.edgeWidth))
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }
}
