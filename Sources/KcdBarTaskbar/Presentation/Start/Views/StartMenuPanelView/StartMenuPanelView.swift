import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

package struct StartMenuPanelView: View {
    package let catalogue: ApplicationCatalogueState
    package let pinned: PinnedAppState
    package let icons: any ApplicationIconPort
    package let userName: String
    package let arrowX: CGFloat
    package let presentation: PopoverPresentation
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onPower: (StartPowerAction) -> Void

    package init(
        catalogue: ApplicationCatalogueState,
        pinned: PinnedAppState,
        icons: any ApplicationIconPort,
        userName: String,
        arrowX: CGFloat,
        presentation: PopoverPresentation,
        onLaunch: @escaping (String) -> Void,
        onTogglePin: @escaping (String) -> Void,
        onPower: @escaping (StartPowerAction) -> Void
    ) {
        self.catalogue = catalogue
        self.pinned = pinned
        self.icons = icons
        self.userName = userName
        self.arrowX = arrowX
        self.presentation = presentation
        self.onLaunch = onLaunch
        self.onTogglePin = onTogglePin
        self.onPower = onPower
    }

    package var body: some View {
        GlassEffectContainer {
            StartMenuSurface(
                catalogue: catalogue,
                pinned: pinned,
                icons: icons,
                userName: userName,
                arrowX: arrowX,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower
            )
        }
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }
}
