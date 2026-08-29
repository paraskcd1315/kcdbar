import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryStack: View {
    package let isVertical: Bool
    package let cornerRadius: CGFloat

    package var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(KbColors.bandFill)
            .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(KbColors.glassEdgeBright.opacity(0.35), lineWidth: TaskbarMetrics.separatorThickness)
            }
            .frame(
                width: isVertical ? nil : TaskbarMetrics.stackWidth,
                height: isVertical ? TaskbarMetrics.stackWidth : nil
            )
            .padding(isVertical ? .horizontal : .vertical, TaskbarMetrics.stackInset)
            .offset(
                x: isVertical ? 0 : TaskbarMetrics.stackPeek,
                y: isVertical ? TaskbarMetrics.stackPeek : 0
            )
            .allowsHitTesting(false)
    }
}
