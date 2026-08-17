import KcdBarTray
import SwiftUI

/** Builds the Start menu's content, so no AppKit host constructs a view. */
@MainActor
package enum StartMenuPresentation {
    package static func content(
        catalogue: ApplicationCatalogueState,
        usage: ApplicationUsageState,
        pinned: PinnedAppState,
        groups: StartGroupState,
        editor: any PanelTextEditingPort,
        icons: any ApplicationIconPort,
        userName: String,
        avatar: Image?,
        presentation: PopoverPresentation,
        arrowX: CGFloat,
        onLaunch: @escaping (String) -> Void,
        onTogglePin: @escaping (String) -> Void,
        onPower: @escaping (StartPowerAction) -> Void,
        onSearch: @escaping () -> Void
    ) -> AnyView {
        AnyView(
            StartMenuPanelView(
                catalogue: catalogue,
                usage: usage,
                pinned: pinned,
                groups: groups,
                editor: editor,
                icons: icons,
                userName: userName,
                avatar: avatar,
                arrowX: arrowX,
                presentation: presentation,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower,
                onSearch: onSearch
            )
        )
    }
}
