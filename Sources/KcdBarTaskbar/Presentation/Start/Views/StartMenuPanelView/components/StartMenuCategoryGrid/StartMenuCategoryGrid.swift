import KcdBarDesignSystem
import SwiftUI

package struct StartMenuCategoryGrid: View {
    package let sections: [ApplicationSection]
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onOpen: (String) -> Void

    package var body: some View {
        LazyVGrid(columns: columns, spacing: KbSpacing.s5) {
            ForEach(sections) { section in
                StartMenuCategoryFolder(
                    section: section,
                    icons: icons,
                    onLaunch: onLaunch,
                    onOpen: { onOpen(section.key) }
                )
            }
        }
        .padding(.horizontal, KbSpacing.s6)
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: KbSpacing.s5),
            count: StartMenuMetrics.folderColumns
        )
    }
}
