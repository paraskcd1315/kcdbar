import KcdBarDesignSystem
import SwiftUI

package struct StartMenuHeader: View {
    package let grouping: StartMenuGrouping
    package let layout: StartMenuLayout
    package let showsIndexButton: Bool
    package let indexKey: String
    package let onSearch: () -> Void
    package let onGrouping: (StartMenuGrouping) -> Void
    package let onLayout: (StartMenuLayout) -> Void
    package let onIndex: () -> Void

    package var body: some View {
        VStack(spacing: KbSpacing.s4) {
            StartMenuSearchField(onOpen: onSearch)
            StartMenuControls(
                grouping: grouping,
                layout: layout,
                showsIndexButton: showsIndexButton,
                indexKey: indexKey,
                onGrouping: onGrouping,
                onLayout: onLayout,
                onIndex: onIndex
            )
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.vertical, KbSpacing.s5)
    }
}
