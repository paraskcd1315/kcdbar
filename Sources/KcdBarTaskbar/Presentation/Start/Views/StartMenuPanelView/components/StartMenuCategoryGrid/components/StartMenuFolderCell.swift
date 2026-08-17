import KcdBarDesignSystem
import SwiftUI

package struct StartMenuFolderCell: View {
    package let applications: [InstalledApplication]
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID

    package var body: some View {
        ZStack {
            if applications.count == 1, let only = applications.first {
                StartMenuAppIcon(
                    icon: icons.icon(forBundleIdentifier: only.bundleIdentifier),
                    size: StartMenuMetrics.folderIconSize
                )
                .matchedGeometryEffect(id: only.bundleIdentifier, in: iconNamespace)
            } else {
                StartMenuFolderMiniGrid(
                    applications: applications,
                    icons: icons,
                    iconNamespace: iconNamespace
                )
            }
        }
        .frame(
            width: StartMenuMetrics.folderIconSize,
            height: StartMenuMetrics.folderIconSize
        )
    }
}
