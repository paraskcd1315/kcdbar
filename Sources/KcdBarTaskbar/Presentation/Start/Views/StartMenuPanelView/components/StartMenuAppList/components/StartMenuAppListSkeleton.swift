import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAppListSkeleton: View {
    package var body: some View {
        VStack(alignment: .leading, spacing: StartMenuMetrics.rowSpacing) {
            ForEach(0..<StartMenuMetrics.skeletonRowCount, id: \.self) { index in
                if StartMenuMetrics.skeletonStartsBand(at: index) {
                    KbSkeleton(width: StartMenuMetrics.skeletonHeadingWidth)
                        .padding(.horizontal, KbSpacing.s6)
                        .padding(.top, KbSpacing.s3)
                }
                StartMenuAppRowSkeleton(
                    labelWidth: StartMenuMetrics.skeletonLabelWidth(at: index)
                )
            }
        }
    }
}
