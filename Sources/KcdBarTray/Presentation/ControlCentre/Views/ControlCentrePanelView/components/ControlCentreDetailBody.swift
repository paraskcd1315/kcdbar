import KcdBarDesignSystem
import SwiftUI

/** Scrolls a detail page's content so its header can never be pushed off the screen. */
package struct ControlCentreDetailBody<Content: View>: View {
    @ViewBuilder package let content: Content

    package init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    package var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: KbSpacing.s3) {
                content
            }
        }
        .frame(maxHeight: KbControlCentreMetrics.detailMaxHeight)
        .scrollBounceBehavior(.basedOnSize)
    }
}
