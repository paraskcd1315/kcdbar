import SwiftUI

struct TaskbarInstanceDots: View {
    let count: Int
    let isFrontmost: Bool

    var body: some View {
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
        min(count, TaskbarMetrics.maximumInstanceDots)
    }
}
