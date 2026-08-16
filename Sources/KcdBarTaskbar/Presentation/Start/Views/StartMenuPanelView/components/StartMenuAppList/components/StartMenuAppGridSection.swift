import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAppGridSection: View {
    package let section: ApplicationSection
    package let showsHeading: Bool
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: StartMenuMetrics.rowSpacing) {
            StartMenuBandHeading(section: section, isShowing: showsHeading)
            LazyVGrid(columns: columns, spacing: KbSpacing.s3) {
                ForEach(section.applications) { application in
                    StartMenuAppTile(
                        application: application,
                        icon: icons.icon(forBundleIdentifier: application.bundleIdentifier),
                        iconNamespace: iconNamespace,
                        isPinned: pinnedIdentifiers.contains(application.bundleIdentifier),
                        onLaunch: { onLaunch(application.bundleIdentifier) },
                        onTogglePin: { onTogglePin(application.bundleIdentifier) }
                    )
                }
            }
            .padding(.horizontal, KbSpacing.s5)
        }
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: KbSpacing.s3),
            count: StartMenuMetrics.gridColumns
        )
    }
}
