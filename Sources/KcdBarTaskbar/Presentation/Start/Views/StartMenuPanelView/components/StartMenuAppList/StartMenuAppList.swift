import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAppList: View {
    package let catalogue: ApplicationCatalogueState
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: StartMenuMetrics.sectionSpacing) {
            StartMenuSectionHeading(title: "start.all")
                .padding(.horizontal, KbSpacing.s6)
            if catalogue.isLoading {
                StartMenuAppListSkeleton()
            } else {
                ForEach(catalogue.sections) { section in
                    StartMenuAppBand(
                        section: section,
                        layout: catalogue.layout,
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
}
