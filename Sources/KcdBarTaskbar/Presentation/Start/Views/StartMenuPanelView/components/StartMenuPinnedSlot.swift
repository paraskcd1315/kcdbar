import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedSlot<Content: View>: View {
    package let isShown: Bool
    @ViewBuilder package let content: () -> Content

    @State private var isExpanded = false
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
        .frame(width: isExpanded ? slotWidth : 0, alignment: .leading)
        .clipped()
        .onAppear {
            isExpanded = isShown
            showsContent = isShown
        }
        .onChange(of: isShown) { _, shown in
            guard shown else {
                withAnimation(KbMotion.quick) { showsContent = false } completion: {
                    isExpanded = false
                }
                return
            }
            isExpanded = true
            withAnimation(KbMotion.standard.delay(KbMotion.standardDuration)) {
                showsContent = true
            }
        }
    }

    private var slotWidth: CGFloat {
        StartMenuMetrics.pinnedPaneWidth + KbEdgeMetrics.width
    }
}
