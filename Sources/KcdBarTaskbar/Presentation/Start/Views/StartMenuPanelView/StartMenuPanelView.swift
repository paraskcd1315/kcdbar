import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

package struct StartMenuPanelView: View {
    package let catalogue: ApplicationCatalogueState
    package let usage: ApplicationUsageState
    package let pinned: PinnedAppState
    package let groups: StartGroupState
    package let editor: any PanelTextEditingPort
    package let icons: any ApplicationIconPort
    package let userName: String
    package let avatar: Image?
    package let arrowX: CGFloat
    package let presentation: PopoverPresentation
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onPower: (StartPowerAction) -> Void
    package let onSearch: () -> Void

    package init(
        catalogue: ApplicationCatalogueState,
        usage: ApplicationUsageState,
        pinned: PinnedAppState,
        groups: StartGroupState,
        editor: any PanelTextEditingPort,
        icons: any ApplicationIconPort,
        userName: String,
        avatar: Image?,
        arrowX: CGFloat,
        presentation: PopoverPresentation,
        onLaunch: @escaping (String) -> Void,
        onTogglePin: @escaping (String) -> Void,
        onPower: @escaping (StartPowerAction) -> Void,
        onSearch: @escaping () -> Void
    ) {
        self.catalogue = catalogue
        self.usage = usage
        self.pinned = pinned
        self.groups = groups
        self.editor = editor
        self.icons = icons
        self.userName = userName
        self.avatar = avatar
        self.arrowX = arrowX
        self.presentation = presentation
        self.onLaunch = onLaunch
        self.onTogglePin = onTogglePin
        self.onPower = onPower
        self.onSearch = onSearch
    }

    package var body: some View {
        GlassEffectContainer {
            StartMenuSurface(
                catalogue: catalogue,
                usage: usage,
                pinned: pinned,
                groups: groups,
                editor: editor,
                icons: icons,
                userName: userName,
                avatar: avatar,
                arrowX: arrowX,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower,
                onSearch: onSearch
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
