import KcdBarDesignSystem
import SwiftUI

package struct StartMenuStickyBar: View {
    package let titleKey: String
    package let glyph: String?
    package let isCollapsed: Bool
    package let onToggle: () -> Void

    @State private var isHovered = false

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            Image(systemName: StartMenuMetrics.disclosureGlyph)
                .font(.system(size: StartMenuMetrics.disclosureSize, weight: .semibold))
                .foregroundStyle(KbColors.onSurfaceMuted)
                .rotationEffect(.degrees(isCollapsed ? 0 : 90))
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
        .background(KbColors.surface.opacity(StartMenuMetrics.stickyFillOpacity))
        .background(
            isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear
        )
        .overlay(alignment: .bottom) {
            LinearGradient(
                colors: [
                    KbColors.surface.opacity(StartMenuMetrics.stickyFillOpacity),
                    KbColors.surface.opacity(0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: StartMenuMetrics.stickyFadeHeight)
            .offset(y: StartMenuMetrics.stickyFadeHeight)
            .allowsHitTesting(false)
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
        .animation(KbMotion.standard, value: isCollapsed)
    }
}
