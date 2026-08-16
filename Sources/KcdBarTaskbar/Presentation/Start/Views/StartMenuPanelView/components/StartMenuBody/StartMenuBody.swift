import KcdBarDesignSystem
import SwiftUI

package struct StartMenuBody: View {
    package let catalogue: ApplicationCatalogueState
    package let usage: ApplicationUsageState
    package let icons: any ApplicationIconPort
    package let pinnedIdentifiers: Set<String>
    package let userName: String
    package let avatar: Image?
    package let height: CGFloat
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onPower: (StartPowerAction) -> Void
    package let onSearch: () -> Void

    @State private var isShowingIndex = false
    @State private var pendingJump: String?
    @Namespace private var iconNamespace
    @Namespace private var recentNamespace

    package var body: some View {
        ScrollViewReader { proxy in
            StartMenuScroller(
                catalogue: catalogue,
                usage: usage,
                icons: icons,
                pinnedIdentifiers: pinnedIdentifiers,
                userName: userName,
                avatar: avatar,
                height: height,
                showsRail: showsIndex,
                isShowingIndex: isShowingIndex,
                availableKeys: availableKeys,
                iconNamespace: iconNamespace,
                recentNamespace: recentNamespace,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower,
                onSearch: onSearch,
                onIndex: { isShowingIndex.toggle() },
                onJump: { key in
                    guard isShowingIndex else {
                        proxy.scrollTo(key, anchor: .top)
                        return
                    }
                    pendingJump = key
                    isShowingIndex = false
                },
                onSectionsAppear: {
                    guard let pendingJump else { return }
                    self.pendingJump = nil
                    proxy.scrollTo(pendingJump, anchor: .top)
                }
            )
            .animation(KbMotion.standard, value: catalogue.grouping)
            .animation(KbMotion.standard, value: catalogue.layout)
            .animation(KbMotion.standard, value: catalogue.openedCategory)
        }
        .frame(width: StartMenuMetrics.sidebarWidth)
    }

    private var showsIndex: Bool {
        catalogue.grouping == .alphabetical && !catalogue.isLoading && !isShowingIndex
    }

    private var availableKeys: Set<String> {
        Set(catalogue.sections.map(\.key))
    }
}
