import KcdBarDesignSystem
import SwiftUI

package struct StartMenuIndexButton: View {
    package let isShowing: Bool
    package let onIndex: () -> Void

    @State private var isHovered = false

    package var body: some View {
        ZStack {
            if isShowing {
                Image(systemName: StartMenuMetrics.indexGlyph)
                    .font(.system(size: StartMenuMetrics.powerGlyphSize, weight: .semibold))
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .frame(
                        width: StartMenuMetrics.powerButtonSize,
                        height: KbSegmentedControlMetrics.height
                    )
                    .glassEffect(.regular.interactive(), in: shape)
                    .overlay(shape.stroke(KbColors.separator, lineWidth: KbEdgeMetrics.width))
                    .background(
                        isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
                        in: shape
                    )
                    .kbTappable(in: shape, perform: onIndex)
                    .onHover { isHovered = $0 }
                    .animation(KbMotion.quick, value: isHovered)
            }
        }
    }

    private var shape: Capsule {
        Capsule()
    }
}
