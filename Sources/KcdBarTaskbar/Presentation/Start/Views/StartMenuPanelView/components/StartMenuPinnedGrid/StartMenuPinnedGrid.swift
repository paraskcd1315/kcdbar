import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedGrid: View {
    package let pinned: [PinnedApp]
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s4) {
            StartMenuSectionHeading(title: "start.pinned")
            LazyVGrid(columns: columns, spacing: KbSpacing.s4) {
                ForEach(pinned) { app in
                    StartMenuPinnedTile(
                        app: app,
                        icon: icons.icon(forBundleIdentifier: app.bundleIdentifier),
                        onLaunch: { onLaunch(app.bundleIdentifier) },
                        onUnpin: { onTogglePin(app.bundleIdentifier) }
                    )
                }
            }
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.vertical, KbSpacing.s3)
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: KbSpacing.s3),
            count: StartMenuMetrics.pinnedColumns
        )
    }
}
