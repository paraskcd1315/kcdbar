import KcdBarDesignSystem
import SwiftUI

package struct StartMenuBody: View {
    package let catalogue: ApplicationCatalogueState
    package let icons: any ApplicationIconPort
    package let pinnedIdentifiers: Set<String>
    package let userName: String
    package let height: CGFloat
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onPower: (StartPowerAction) -> Void
    package let onSearch: () -> Void

    @State private var isShowingIndex = false
    @Namespace private var iconNamespace

    package var body: some View {
        ScrollViewReader { proxy in
            StartMenuScroller(
                catalogue: catalogue,
                icons: icons,
                pinnedIdentifiers: pinnedIdentifiers,
                userName: userName,
                height: height,
                showsRail: showsIndex,
                availableKeys: availableKeys,
                iconNamespace: iconNamespace,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower,
                onSearch: onSearch,
                onIndex: { isShowingIndex = true },
                onJump: { proxy.scrollTo($0, anchor: .top) }
            )
            .animation(KbMotion.standard, value: catalogue.grouping)
            .animation(KbMotion.standard, value: catalogue.layout)
            .animation(KbMotion.standard, value: catalogue.openedCategory)
            .animation(KbMotion.quick, value: isShowingIndex)
            .overlay {
                StartMenuIndexOverlay(
                    isShowing: isShowingIndex,
                    availableKeys: availableKeys,
                    onJump: { proxy.scrollTo($0, anchor: .top) },
                    onDismiss: { isShowingIndex = false }
                )
            }
        }
        .frame(width: StartMenuMetrics.sidebarWidth)
    }

    private var showsIndex: Bool {
        catalogue.grouping == .alphabetical && !catalogue.isLoading
    }

    private var availableKeys: Set<String> {
        Set(catalogue.sections.map(\.key))
    }
}
