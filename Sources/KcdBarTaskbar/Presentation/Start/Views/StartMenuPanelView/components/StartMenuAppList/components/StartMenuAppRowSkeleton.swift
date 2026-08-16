import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAppRowSkeleton: View {
    package let labelWidth: CGFloat

    package var body: some View {
        HStack(spacing: KbSpacing.s4) {
            KbSkeleton(
                width: StartMenuMetrics.rowIconSize,
                height: StartMenuMetrics.rowIconSize,
                shape: AnyShape(RoundedRectangle(cornerRadius: KbRadii.md, style: .continuous))
            )
            KbSkeleton(width: labelWidth)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, KbSpacing.s4)
        .padding(.vertical, KbSpacing.s3)
        .padding(.horizontal, KbSpacing.s5)
    }
}
