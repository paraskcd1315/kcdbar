import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedBar: View {
    package let onAdd: () -> Void

    @State private var isHovered = false

    package var body: some View {
        HStack(spacing: KbSpacing.s3) {
            StartMenuSectionHeading(title: "start.pinned")
            Spacer(minLength: 0)
            Image(systemName: StartMenuMetrics.addGlyph)
                .font(.system(size: StartMenuMetrics.powerGlyphSize, weight: .semibold))
                .foregroundStyle(KbColors.onSurfaceMuted)
                .frame(
                    width: StartMenuMetrics.powerButtonSize,
                    height: StartMenuMetrics.powerButtonSize
                )
                .background(
                    isHovered ? KbColors.onSurface.opacity(StartMenuMetrics.hoverFillOpacity) : .clear,
                    in: Circle()
                )
                .kbTappable(in: Circle(), perform: onAdd)
                .onHover { isHovered = $0 }
                .animation(KbMotion.quick, value: isHovered)
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.vertical, KbSpacing.s5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular.interactive(), in: Rectangle())
    }
}
