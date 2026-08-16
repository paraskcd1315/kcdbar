import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAppGridSection: View {
    package let section: ApplicationSection
    package let showsHeading: Bool
    package let onIndex: () -> Void
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: StartMenuMetrics.rowSpacing) {
            StartMenuBandHeading(section: section, isShowing: showsHeading, onIndex: onIndex)
            StartMenuAppGrid(
                applications: section.applications,
                pinnedIdentifiers: pinnedIdentifiers,
                icons: icons,
                iconNamespace: iconNamespace,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin
            )
        }
    }
}
