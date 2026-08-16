import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedSlot<Content: View>: View {
    package let isShown: Bool
    @ViewBuilder package let content: () -> Content

    @State private var showsContent = false

    package var body: some View {
        HStack(alignment: .top, spacing: 0) {
            StartMenuPaneDivider()
            content()
                .frame(width: StartMenuMetrics.pinnedPaneWidth, alignment: .leading)
                .opacity(showsContent ? 1 : 0)
                .scaleEffect(
                    showsContent ? 1 : StartMenuMetrics.pinnedRevealScale,
                    anchor: .leading
                )
        }
        .frame(width: isShown ? slotWidth : 0, alignment: .leading)
        .clipped()
        .animation(KbMotion.standard, value: isShown)
        .onAppear { showsContent = isShown }
        .onChange(of: isShown) { _, shown in
            withAnimation(shown ? KbMotion.standard.delay(KbMotion.standardDuration) : KbMotion.quick) {
                showsContent = shown
            }
        }
    }

    private var slotWidth: CGFloat {
        StartMenuMetrics.pinnedPaneWidth + KbEdgeMetrics.width
    }
}
