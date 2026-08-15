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
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .background(Capsule().fill(KbColors.onSurface.opacity(isHovered ? TaskbarMetrics.hoverFillOpacity : 0)))
        .scaleEffect(isHovered ? TaskbarMetrics.hoverScale : 1)
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
    }
}
