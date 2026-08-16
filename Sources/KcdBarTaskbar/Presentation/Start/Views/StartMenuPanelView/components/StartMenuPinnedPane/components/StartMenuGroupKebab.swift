import KcdBarDesignSystem
import SwiftUI

package struct StartMenuGroupKebab: View {
    package let onRename: () -> Void
    package let onRemove: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Menu {
            Button("start.group.rename", action: onRename)
            Button("start.group.remove", role: .destructive, action: onRemove)
        } label: {
            Image(systemName: StartMenuMetrics.kebabGlyph)
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
                .contentShape(Circle())
        }
        .menuStyle(.borderlessButton)
        .menuIndicator(.hidden)
        .fixedSize()
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }
}
