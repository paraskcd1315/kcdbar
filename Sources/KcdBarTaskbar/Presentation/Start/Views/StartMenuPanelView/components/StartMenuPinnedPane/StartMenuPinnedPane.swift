import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedPane: View {
    package let sections: [ApplicationSection]
    package let icons: any ApplicationIconPort
    package let height: CGFloat
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: KbSpacing.s5) {
                ForEach(sections) { section in
                    StartMenuPinnedGroup(
                        section: section,
                        icons: icons,
                        onLaunch: onLaunch,
                        onTogglePin: onTogglePin
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, KbSpacing.s6)
            .padding(.vertical, KbSpacing.s5)
            .contentShape(Rectangle())
        }
        .frame(width: StartMenuMetrics.pinnedPaneWidth, height: height)
        .safeAreaBar(edge: .top) {
            StartMenuSectionHeading(title: "start.pinned")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, KbSpacing.s6)
                .padding(.vertical, KbSpacing.s5)
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}
