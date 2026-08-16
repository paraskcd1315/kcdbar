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
    @Namespace private var iconNamespace

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
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower,
                onSearch: onSearch,
                onIndex: {
                    isShowingIndex.toggle()
                    if isShowingIndex { proxy.scrollTo(StartMenuMetrics.topAnchorKey, anchor: .top) }
                },
                onJump: { key in
                    isShowingIndex = false
                    proxy.scrollTo(key, anchor: .top)
                }
            )
            .onChange(of: catalogue.isLoading) { _, isLoading in
                guard !isLoading else { return }
                proxy.scrollTo(StartMenuMetrics.topAnchorKey, anchor: .top)
            }
            .onChange(of: recentCount) { _, _ in
                proxy.scrollTo(StartMenuMetrics.topAnchorKey, anchor: .top)
            }
            .animation(KbMotion.standard, value: catalogue.grouping)
            .animation(KbMotion.standard, value: catalogue.layout)
            .animation(KbMotion.standard, value: catalogue.openedCategory)
        }
        .frame(width: StartMenuMetrics.sidebarWidth)
    }

    private var showsIndex: Bool {
        catalogue.grouping == .alphabetical && !catalogue.isLoading && !isShowingIndex
    }

    private var recentCount: Int {
        usage.recents(among: catalogue.applications).count
    }

    private var availableKeys: Set<String> {
        Set(catalogue.sections.map(\.key))
    }
}
