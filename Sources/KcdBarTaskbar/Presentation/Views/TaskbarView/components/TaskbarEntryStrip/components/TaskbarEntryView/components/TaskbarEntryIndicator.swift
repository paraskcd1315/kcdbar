import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryIndicator: View {
    package let entry: TaskbarEntryModel

    package var body: some View {
        if TaskbarEntryStyle.isOpenHere(entry) {
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: TaskbarMetrics.openBorderHeight)
                    .fill(entry.isFrontmost ? KbColors.activeIndicator : KbColors.onSurfaceMuted)
                    .frame(
                        width: entry.isFrontmost
                            ? proxy.size.width
                            : proxy.size.width * TaskbarMetrics.inactiveBorderFraction,
                        height: entry.isFrontmost
                            ? TaskbarMetrics.focusedBorderHeight
                            : TaskbarMetrics.openBorderHeight
                    )
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottom)
            }
            .frame(height: TaskbarMetrics.focusedBorderHeight)
            .animation(KbMotion.quick, value: entry.isFrontmost)
        } else if entry.instanceCount > 0 || entry.isRunning {
            TaskbarInstanceDots(
                count: entry.instanceCount,
                isRunning: entry.isRunning,
                isFrontmost: entry.isFrontmost
            )
            .padding(.bottom, TaskbarMetrics.instanceDotInset)
        }
    }
}
