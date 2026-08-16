import KcdBarDesignSystem
import SwiftUI

package struct StartMenuRecents: View {
    package let applications: [InstalledApplication]
    package let layout: StartMenuLayout
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        Group {
            if layout == .grid {
                StartMenuAppGrid(
                    applications: applications,
                    pinnedIdentifiers: pinnedIdentifiers,
                    icons: icons,
                    iconNamespace: iconNamespace,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin
                )
            } else {
                StartMenuAppRows(
                    applications: applications,
                    pinnedIdentifiers: pinnedIdentifiers,
                    icons: icons,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin
                )
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
