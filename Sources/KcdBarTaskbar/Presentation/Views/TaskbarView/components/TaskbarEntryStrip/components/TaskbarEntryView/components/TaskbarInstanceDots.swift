import KcdBarDesignSystem
import SwiftUI

package struct TaskbarInstanceDots: View {
    package let count: Int
    package let isRunning: Bool
    package let isFrontmost: Bool

    package var body: some View {
        HStack(spacing: TaskbarMetrics.instanceDotSpacing) {
            ForEach(0..<shownCount, id: \.self) { _ in
                Circle()
                    .fill(isFrontmost ? KbColors.activeIndicator : KbColors.onSurfaceMuted)
                    .frame(width: TaskbarMetrics.instanceDotSize, height: TaskbarMetrics.instanceDotSize)
            }
        }
        .frame(height: TaskbarMetrics.instanceDotSize)
    }

    private var shownCount: Int {
        min(
            TaskbarDotCount.dots(windows: count, isRunning: isRunning),
            TaskbarMetrics.maximumInstanceDots
        )
    }
}
