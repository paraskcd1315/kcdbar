import SwiftUI

struct TaskbarStartButton: View {
    let onOpen: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onOpen) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: TaskbarMetrics.startGlyphSize, weight: .medium))
                .foregroundStyle(KbColors.onSurface)
                .frame(width: TaskbarMetrics.startButtonWidth)
                .frame(maxHeight: .infinity)
                .contentShape(.rect(cornerRadius: KbRadii.md))
        }
        .buttonStyle(.plain)
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: .rect(cornerRadius: KbRadii.md))
        .scaleEffect(isHovered ? TaskbarMetrics.hoverScale : 1)
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
    }
}
