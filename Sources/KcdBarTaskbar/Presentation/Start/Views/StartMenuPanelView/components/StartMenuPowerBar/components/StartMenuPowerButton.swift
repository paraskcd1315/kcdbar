import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPowerButton: View {
    package let action: StartPowerAction
    package let onPower: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Image(systemName: action.symbol)
            .font(.system(size: StartMenuMetrics.powerGlyphSize, weight: .medium))
            .foregroundStyle(KbColors.onSurface)
            .frame(
                width: StartMenuMetrics.powerButtonSize,
                height: StartMenuMetrics.powerButtonSize
            )
            .background(
                isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
                in: shape
            )
            .kbTappable(in: shape, perform: onPower)
            .help(Text(LocalizedStringKey(action.titleKey)))
            .onHover { isHovered = $0 }
            .animation(KbMotion.quick, value: isHovered)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.sm, style: .continuous)
    }
}
