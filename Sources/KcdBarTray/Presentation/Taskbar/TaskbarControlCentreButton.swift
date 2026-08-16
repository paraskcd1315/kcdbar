import KcdBarDesignSystem
import SwiftUI

package struct TaskbarControlCentreButton: View {
    package let onOpen: () -> Void

    @State private var isHovered = false

    package init(onOpen: @escaping () -> Void) {
        self.onOpen = onOpen
    }

    package var body: some View {
        Image(systemName: TrayItemMetrics.glyphSymbol)
            .font(KbTypography.controlCentreGlyph)
            .foregroundStyle(KbColors.onSurface)
            .frame(width: TrayItemMetrics.controlCentreWidth)
            .padding(.vertical, KbSpacing.s2)
            .kbTappable(in: shape, perform: onOpen)
            .glassEffect(isHovered ? .regular.interactive() : .identity, in: shape)
            .animation(KbMotion.quick, value: isHovered)
            .onHover { isHovered = $0 }
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
