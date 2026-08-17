import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAppList: View {
    package let catalogue: ApplicationCatalogueState
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onIndex: () -> Void
    package let onScrollTop: () -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: StartMenuMetrics.sectionSpacing) {
            StartMenuOpenedHeading(
                opened: catalogue.openedSection,
                onBack: {
                    catalogue.closeCategory()
                    onScrollTop()
                }
            )
            StartMenuCatalogueContent(
                catalogue: catalogue,
                pinnedIdentifiers: pinnedIdentifiers,
                icons: icons,
                iconNamespace: iconNamespace,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onOpenCategory: {
                    catalogue.open(category: $0)
                    onScrollTop()
                },
                onIndex: onIndex
            )
        }
    }
}
