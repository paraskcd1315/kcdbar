import KcdBarDesignSystem
import SwiftUI

package struct TaskbarStartButton: View {
    package let onOpen: () -> Void
    package let onOpenSettings: () -> Void
    package let loginItem: LoginItemState

    @State private var isHovered = false

    package var body: some View {
        Button(action: onOpen) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: TaskbarMetrics.startGlyphSize, weight: .medium))
                .foregroundStyle(KbColors.onSurface)
                .frame(width: TaskbarMetrics.iconSize, height: TaskbarMetrics.iconSize)
                .padding(KbSpacing.s3)
                .contentShape(.rect(cornerRadius: KbRadii.md))
        }
        .buttonStyle(.plain)
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: .rect(cornerRadius: KbRadii.md))
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
        .contextMenu {
            Toggle("taskbar.menu.launchAtLogin", isOn: launchAtLogin)
            Divider()
            Button("taskbar.menu.settings", action: onOpenSettings)
        }
        .onAppear { loginItem.refresh() }
    }

    private var launchAtLogin: Binding<Bool> {
        Binding(get: { loginItem.isEnabled }, set: { _ in loginItem.toggle() })
    }
}
