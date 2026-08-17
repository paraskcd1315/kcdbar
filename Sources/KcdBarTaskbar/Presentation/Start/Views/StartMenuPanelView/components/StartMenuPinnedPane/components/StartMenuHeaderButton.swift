import KcdBarDesignSystem
import SwiftUI

package struct StartMenuHeaderButton: View {
    package let glyph: String
    package let titleKey: LocalizedStringKey
    package let isDestructive: Bool
    package let action: () -> Void

    @State private var isHovered = false

    package init(
        glyph: String,
        titleKey: LocalizedStringKey,
        isDestructive: Bool = false,
        action: @escaping () -> Void
    ) {
        self.glyph = glyph
        self.titleKey = titleKey
        self.isDestructive = isDestructive
        self.action = action
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s2) {
            Image(systemName: glyph)
                .font(.system(size: StartMenuMetrics.powerGlyphSize, weight: .semibold))
            Text(titleKey)
                .font(KbTypography.entryTitle)
        }
        .foregroundStyle(isDestructive ? KbColors.batteryCritical : KbColors.onSurface)
        .padding(.horizontal, KbSpacing.s4)
        .frame(height: StartMenuMetrics.powerButtonSize)
        .glassEffect(.regular.interactive(), in: Capsule())
        .overlay(Capsule().stroke(KbColors.separator, lineWidth: KbEdgeMetrics.width))
        .background(
            isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
            in: Capsule()
        )
        .kbTappable(in: Capsule(), perform: action)
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }
}
