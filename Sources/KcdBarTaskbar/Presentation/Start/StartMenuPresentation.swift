import KcdBarTray
import SwiftUI

/** Builds the Start menu's content, so no AppKit host constructs a view. */
@MainActor
package enum StartMenuPresentation {
    package static func content(
        catalogue: ApplicationCatalogueState,
        pinned: PinnedAppState,
        icons: any ApplicationIconPort,
        userName: String,
        presentation: PopoverPresentation,
        arrowX: CGFloat,
        onLaunch: @escaping (String) -> Void,
        onTogglePin: @escaping (String) -> Void,
        onPower: @escaping (StartPowerAction) -> Void
    ) -> AnyView {
        AnyView(
            StartMenuPanelView(
                catalogue: catalogue,
                pinned: pinned,
                icons: icons,
                userName: userName,
                arrowX: arrowX,
                presentation: presentation,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower
            )
        )
    }
}
