import SwiftUI

struct TaskbarDropIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: TaskbarMetrics.dropIndicatorWidth / 2)
            .fill(KbColors.activeIndicator)
            .frame(width: TaskbarMetrics.dropIndicatorWidth)
            .transition(.opacity.combined(with: .scale(scale: TaskbarMetrics.dropIndicatorAppearScale)))
    }
}
