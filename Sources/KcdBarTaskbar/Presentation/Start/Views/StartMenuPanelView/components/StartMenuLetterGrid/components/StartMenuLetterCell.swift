import KcdBarDesignSystem
import SwiftUI

package struct StartMenuLetterCell: View {
    package let key: String
    package let isAvailable: Bool
    package let onSelect: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Text(key)
            .font(KbTypography.menuHeading)
            .foregroundStyle(KbColors.onSurface)
            .opacity(isAvailable ? 1 : StartMenuMetrics.disabledLetterOpacity)
            .frame(width: StartMenuMetrics.letterGridCellSize, height: StartMenuMetrics.letterGridCellSize)
            .background(
                isHovered && isAvailable
                    ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity)
                    : .clear,
                in: shape
            )
            .kbTappable(in: shape) { if isAvailable { onSelect() } }
            .onHover { isHovered = $0 }
            .animation(KbMotion.quick, value: isHovered)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.sm, style: .continuous)
    }
}
