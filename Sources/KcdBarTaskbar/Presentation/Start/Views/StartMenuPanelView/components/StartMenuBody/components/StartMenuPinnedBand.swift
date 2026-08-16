import KcdBarDesignSystem
import SwiftUI

package struct StartMenuPinnedBand: View {
    package let pinned: PinnedAppState
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        ZStack {
            if !pinned.apps.isEmpty {
                VStack(alignment: .leading, spacing: KbSpacing.s5) {
                    StartMenuPinnedGrid(
                        pinned: pinned.apps,
                        icons: icons,
                        onLaunch: onLaunch,
                        onTogglePin: onTogglePin
                    )
                    StartMenuDivider()
                }
            }
        }
    }
}
