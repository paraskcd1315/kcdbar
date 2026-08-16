import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAppBand: View {
    package let section: ApplicationSection
    package let layout: StartMenuLayout
    package let showsHeading: Bool
    package let onIndex: () -> Void
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        ZStack {
            if layout == .list {
                StartMenuAppSection(
                    section: section,
                    showsHeading: showsHeading,
                    onIndex: onIndex,
                    pinnedIdentifiers: pinnedIdentifiers,
                    icons: icons,
                    iconNamespace: iconNamespace,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin
                )
            } else {
                StartMenuAppGridSection(
                    section: section,
                    showsHeading: showsHeading,
                    onIndex: onIndex,
                    pinnedIdentifiers: pinnedIdentifiers,
                    icons: icons,
                    iconNamespace: iconNamespace,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin
                )
            }
        }
    }
}
