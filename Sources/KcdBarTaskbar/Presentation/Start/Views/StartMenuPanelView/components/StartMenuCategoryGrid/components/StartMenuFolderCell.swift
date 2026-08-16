import KcdBarDesignSystem
import SwiftUI

package struct StartMenuFolderCell: View {
    package let applications: [InstalledApplication]
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void

    package var body: some View {
        ZStack {
            if applications.count == 1, let only = applications.first {
                StartMenuAppIcon(
                    icon: icons.icon(forBundleIdentifier: only.bundleIdentifier),
                    size: StartMenuMetrics.folderIconSize
                )
                .kbTappable(in: Rectangle()) { onLaunch(only.bundleIdentifier) }
            } else {
                StartMenuFolderMiniGrid(applications: applications, icons: icons)
            }
        }
        .frame(
            width: StartMenuMetrics.folderIconSize,
            height: StartMenuMetrics.folderIconSize
        )
    }
}
