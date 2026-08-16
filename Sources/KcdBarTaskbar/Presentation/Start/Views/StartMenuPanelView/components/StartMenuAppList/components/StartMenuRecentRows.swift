import KcdBarDesignSystem
import SwiftUI

package struct StartMenuRecentRows: View {
    package let applications: [InstalledApplication]
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: StartMenuMetrics.rowSpacing) {
            ForEach(applications) { application in
                StartMenuAppRow(
                    application: application,
                    icon: icons.icon(forBundleIdentifier: application.bundleIdentifier),
                    isPinned: pinnedIdentifiers.contains(application.bundleIdentifier),
                    onLaunch: { onLaunch(application.bundleIdentifier) },
                    onTogglePin: { onTogglePin(application.bundleIdentifier) }
                )
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
