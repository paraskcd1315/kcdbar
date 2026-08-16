import KcdBarDesignSystem
import SwiftUI

package struct StartMenuIndexButton: View {
    package let isShowing: Bool
    package let key: String
    package let onIndex: () -> Void

    @State private var isHovered = false

    package var body: some View {
        ZStack {
            if isShowing {
                Text(key)
                    .font(KbTypography.menuHeading)
                    .foregroundStyle(KbColors.onSurface)
                    .contentTransition(.numericText())
                    .frame(
                        width: StartMenuMetrics.indexButtonWidth,
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
                    .animation(KbMotion.standard, value: key)
            }
        }
        .transition(.scale.combined(with: .opacity))
    }

    private var shape: Capsule {
        Capsule()
    }
}
