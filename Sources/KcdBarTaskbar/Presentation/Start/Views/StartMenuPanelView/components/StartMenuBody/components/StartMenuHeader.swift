import KcdBarDesignSystem
import SwiftUI

package struct StartMenuHeader: View {
    package let grouping: StartMenuGrouping
    package let layout: StartMenuLayout
    package let isAllCollapsed: Bool
    package let onSearch: () -> Void
    package let onGrouping: (StartMenuGrouping) -> Void
    package let onLayout: (StartMenuLayout) -> Void
    package let onToggleAll: () -> Void

    package var body: some View {
        VStack(spacing: KbSpacing.s4) {
            StartMenuSearchField(onOpen: onSearch)
            StartMenuControls(
                grouping: grouping,
                layout: layout,
                onGrouping: onGrouping,
                onLayout: onLayout
            )
            StartMenuStickyBar(
                titleKey: "start.all",
                glyph: nil,
                isCollapsed: isAllCollapsed,
                onToggle: onToggleAll
            )
            .padding(.horizontal, -KbSpacing.s6)
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.vertical, KbSpacing.s5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular.interactive(), in: Rectangle())
    }
}
