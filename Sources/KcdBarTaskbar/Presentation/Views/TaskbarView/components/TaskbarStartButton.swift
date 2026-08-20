import KcdBarDesignSystem
import SwiftUI

package struct TaskbarStartButton: View {
    package let iconSize: CGFloat
    package let cornerRadius: CGFloat
    package let onOpen: () -> Void
    package let onOpenSettings: () -> Void

    @State private var isHovered = false

    package var body: some View {
        Button(action: onOpen) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: TaskbarMetrics.startGlyphSize, weight: .medium))
                .foregroundStyle(KbColors.onSurface)
                .frame(width: iconSize, height: iconSize)
                .padding(KbSpacing.s3)
                .contentShape(.rect(cornerRadius: cornerRadius))
        }
        .buttonStyle(.plain)
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: .rect(cornerRadius: cornerRadius))
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
        .contextMenu {
            Button("taskbar.menu.settings", action: onOpenSettings)
        }
    }
}
