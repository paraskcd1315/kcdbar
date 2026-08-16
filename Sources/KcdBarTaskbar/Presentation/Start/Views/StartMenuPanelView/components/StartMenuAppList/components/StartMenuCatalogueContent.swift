import KcdBarDesignSystem
import SwiftUI

package struct StartMenuCatalogueContent: View {
    package let catalogue: ApplicationCatalogueState
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onOpenCategory: (String) -> Void

    package var body: some View {
        if catalogue.isLoading {
            StartMenuAppListSkeleton()
        } else if catalogue.showsFolders {
            StartMenuCategoryGrid(
                sections: catalogue.sections,
                icons: icons,
                onLaunch: onLaunch,
                onOpen: onOpenCategory
            )
        } else {
            ForEach(catalogue.visibleSections) { section in
                StartMenuAppBand(
                    section: section,
                    layout: catalogue.layout,
                    showsHeading: catalogue.openedSection == nil,
                    pinnedIdentifiers: pinnedIdentifiers,
                    icons: icons,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin
                )
                .id(section.key)
            }
        }
    }
}
