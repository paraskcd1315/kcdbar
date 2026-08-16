import SwiftUI

package struct StartMenuFolderMiniGrid: View {
    package let applications: [InstalledApplication]
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID

    package var body: some View {
        LazyVGrid(columns: columns, spacing: StartMenuMetrics.rowSpacing) {
            ForEach(applications.prefix(StartMenuMetrics.folderPreviewCount)) { application in
                StartMenuAppIcon(
                    icon: icons.icon(forBundleIdentifier: application.bundleIdentifier),
                    size: StartMenuMetrics.folderMiniIconSize
                )
                .matchedGeometryEffect(id: application.bundleIdentifier, in: iconNamespace)
            }
        }
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.fixed(StartMenuMetrics.folderMiniIconSize), spacing: StartMenuMetrics.rowSpacing),
            count: StartMenuMetrics.folderFaceColumns
        )
    }
}
