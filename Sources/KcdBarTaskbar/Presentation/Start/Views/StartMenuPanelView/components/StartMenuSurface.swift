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

    package var body: some View {
        StartMenuBody(
            catalogue: catalogue,
            pinned: pinned,
            icons: icons,
            userName: userName,
            onLaunch: onLaunch,
            onTogglePin: onTogglePin,
            onPower: onPower
        )
        .frame(width: StartMenuMetrics.panelWidth, alignment: .leading)
        .clipShape(KbPopoverShape(arrowX: arrowX))
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: arrowX))
        .overlay { KbPopoverEdge(arrowX: arrowX) }
        .task { await catalogue.load() }
    }
}
