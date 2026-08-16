import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedGroup: View {
    package let section: ApplicationSection
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            StartMenuBandHeading(section: section, isShowing: true)
            LazyVGrid(columns: columns, spacing: KbSpacing.s3) {
                ForEach(section.applications) { application in
                    StartMenuPinnedTile(
                        app: PinnedApp(
                            bundleIdentifier: application.bundleIdentifier,
                            displayName: application.displayName,
                            order: 0
                        ),
                        icon: icons.icon(forBundleIdentifier: application.bundleIdentifier),
                        onLaunch: { onLaunch(application.bundleIdentifier) },
                        onUnpin: { onTogglePin(application.bundleIdentifier) }
                    )
                }
            }
        }
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: KbSpacing.s3),
            count: StartMenuMetrics.pinnedColumns
        )
    }
}
