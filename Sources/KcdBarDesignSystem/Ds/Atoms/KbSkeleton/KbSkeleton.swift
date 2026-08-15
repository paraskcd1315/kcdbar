import SwiftUI

/** A shimmering placeholder standing in for content that has not arrived. */
package struct KbSkeleton: View {
    package var width: CGFloat?
    package var height: CGFloat = KbSkeletonMetrics.lineHeight

    @State private var isShimmering = false

    package init(width: CGFloat? = nil, height: CGFloat = KbSkeletonMetrics.lineHeight) {
        self.width = width
        self.height = height
    }

    package var body: some View {
        Capsule()
            .fill(KbColors.onSurface.opacity(KbSkeletonMetrics.baseOpacity))
            .frame(width: width, height: height)
            .frame(maxWidth: width == nil ? .infinity : nil, alignment: .leading)
            .opacity(isShimmering ? KbSkeletonMetrics.shimmerOpacity : 1)
            .animation(
                .easeInOut(duration: KbSkeletonMetrics.shimmerDuration).repeatForever(),
                value: isShimmering
            )
            .onAppear { isShimmering = true }
    }
}
