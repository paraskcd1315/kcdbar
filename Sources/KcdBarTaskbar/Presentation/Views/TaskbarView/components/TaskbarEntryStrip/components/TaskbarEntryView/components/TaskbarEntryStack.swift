import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryStack: View {
    package let shape: AnyShape
    package let isVertical: Bool

    package var body: some View {
        shape
            .fill(KbColors.bandFill.opacity(TaskbarMetrics.stackOpacity))
            .overlay {
                shape.stroke(KbColors.separator, lineWidth: TaskbarMetrics.separatorThickness)
            }
            .padding(inset, TaskbarMetrics.stackInset)
            .offset(
                x: isVertical ? 0 : TaskbarMetrics.stackOffset,
                y: isVertical ? TaskbarMetrics.stackOffset : -TaskbarMetrics.stackOffset
            )
    }

    private var inset: Edge.Set {
        isVertical ? .vertical : .horizontal
    }
}
