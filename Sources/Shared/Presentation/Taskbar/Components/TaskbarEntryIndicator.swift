import SwiftUI

struct TaskbarEntryIndicator: View {
    let isFrontmost: Bool
    let isMinimized: Bool

    var body: some View {
        Capsule()
            .fill(isFrontmost ? KbColors.activeIndicator : KbColors.onSurfaceMuted)
            .frame(width: TaskbarMetrics.indicatorWidth, height: TaskbarMetrics.indicatorHeight)
            .opacity(isMinimized ? 0.35 : 1)
    }
}
