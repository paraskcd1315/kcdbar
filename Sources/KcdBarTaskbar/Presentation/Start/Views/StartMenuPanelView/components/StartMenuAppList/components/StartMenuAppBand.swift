import KcdBarDesignSystem
import SwiftUI

package struct StartMenuAppBand: View {
    package let section: ApplicationSection
    package let layout: StartMenuLayout
    package let showsHeading: Bool
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        ZStack {
            if layout == .list {
                StartMenuAppSection(
                    section: section,
                    showsHeading: showsHeading,
                    pinnedIdentifiers: pinnedIdentifiers,
                    icons: icons,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin
                )
            } else {
                StartMenuAppGridSection(
                    section: section,
                    showsHeading: showsHeading,
                    pinnedIdentifiers: pinnedIdentifiers,
                    icons: icons,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin
                )
            }
        }
    }
}
