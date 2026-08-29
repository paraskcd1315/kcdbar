import KcdBarDesignSystem
import SwiftUI

package struct TaskbarEntryBadgeCount: View {
    package let count: Int

    package var body: some View {
        Text(verbatim: "\(count)")
            .font(.system(size: TaskbarMetrics.fullScreenCountFont, weight: .bold))
            .foregroundStyle(KbColors.onBrand)
            .frame(width: TaskbarMetrics.fullScreenCountSide, height: TaskbarMetrics.fullScreenCountSide)
            .background(KbColors.brand, in: .circle)
    }
}
