import KcdBarDesignSystem
import SwiftUI

package struct StartMenuSurface: View {
    package let catalogue: ApplicationCatalogueState
    package let pinned: PinnedAppState
    package let icons: any ApplicationIconPort
    package let userName: String
    package let arrowX: CGFloat
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onPower: (StartPowerAction) -> Void
    package let onSearch: () -> Void

    package var body: some View {
        HStack(spacing: 0) {
            StartMenuBody(
                catalogue: catalogue,
                icons: icons,
                pinnedIdentifiers: Set(pinned.apps.map(\.bundleIdentifier)),
                userName: userName,
                height: catalogue.bodyHeight,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower,
                onSearch: onSearch
            )
            StartMenuPaneDivider()
            StartMenuPinnedPane(
                sections: StartPinnedSections.of(
                    pinned.apps,
                    categories: catalogue.categoriesByBundleIdentifier
                ),
                icons: icons,
                height: catalogue.bodyHeight,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin
            )
        }
        .frame(width: StartMenuMetrics.panelWidth, alignment: .leading)
        .clipShape(KbPopoverShape(arrowX: arrowX))
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: arrowX))
        .overlay { KbPopoverEdge(arrowX: arrowX) }
        .task { await catalogue.load() }
    }
}
