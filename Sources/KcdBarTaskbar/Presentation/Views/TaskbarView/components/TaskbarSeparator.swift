import KcdBarDesignSystem
import SwiftUI

package struct TaskbarSeparator: View {
    package let isVertical: Bool

    package var body: some View {
        Rectangle()
            .fill(KbColors.separator)
            .frame(
                width: isVertical ? nil : TaskbarMetrics.separatorThickness,
                height: isVertical ? TaskbarMetrics.separatorThickness : nil
            )
            .frame(
                maxWidth: isVertical ? .infinity : nil,
                maxHeight: isVertical ? nil : .infinity
            )
            .padding(isVertical ? .vertical : .horizontal, TaskbarMetrics.separatorInset)
    }
}
