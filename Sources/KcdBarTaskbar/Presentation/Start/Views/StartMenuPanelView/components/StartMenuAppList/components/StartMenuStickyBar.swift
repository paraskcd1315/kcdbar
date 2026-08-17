import KcdBarDesignSystem
import SwiftUI

package struct StartMenuStickyBar: View {
    package let titleKey: String
    package let glyph: String?
    package var isCollapsed = false
    package var onToggle: (() -> Void)?

    @State private var isHovered = false

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            if onToggle != nil {
                Image(systemName: StartMenuMetrics.disclosureGlyph)
                    .font(.system(size: StartMenuMetrics.disclosureSize, weight: .semibold))
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .rotationEffect(.degrees(isCollapsed ? 0 : 90))
            }
            if let glyph {
                Image(systemName: glyph)
                    .font(.system(size: StartMenuMetrics.disclosureSize, weight: .semibold))
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
            StartMenuSectionHeading(title: LocalizedStringKey(titleKey))
            Spacer(minLength: 0)
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.vertical, KbSpacing.s3)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear
        )
        .glassEffect(.regular.interactive(), in: Rectangle())
        .contentShape(Rectangle())
        .onTapGesture { onToggle?() }
        .onHover { isHovered = onToggle != nil && $0 }
        .animation(KbMotion.quick, value: isHovered)
        .animation(KbMotion.standard, value: isCollapsed)
    }
}
