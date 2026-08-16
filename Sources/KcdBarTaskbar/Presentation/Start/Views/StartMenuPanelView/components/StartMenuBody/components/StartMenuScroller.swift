import KcdBarDesignSystem
import SwiftUI

package struct StartMenuScroller: View {
    package let catalogue: ApplicationCatalogueState
    package let usage: ApplicationUsageState
    package let icons: any ApplicationIconPort
    package let pinnedIdentifiers: Set<String>
    package let userName: String
    package let avatar: Image?
    package let height: CGFloat
    package let showsRail: Bool
    package let isShowingIndex: Bool
    package let availableKeys: Set<String>
    package let iconNamespace: Namespace.ID
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onPower: (StartPowerAction) -> Void
    package let onSearch: () -> Void
    package let onIndex: () -> Void
    package let onJump: (String) -> Void

    package var body: some View {
        ScrollView {
            ZStack(alignment: .top) {
                if isShowingIndex {
                    StartMenuLetterGrid(
                        keys: ApplicationIndexKeys.all,
                        available: availableKeys,
                        recents: recents,
                        icons: icons,
                        onSelect: onJump,
                        onLaunch: onLaunch
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                } else {
                    StartMenuSections(
                        catalogue: catalogue,
                        usage: usage,
                        recents: recents,
                        pinnedIdentifiers: pinnedIdentifiers,
                        icons: icons,
                        iconNamespace: iconNamespace,
                        onLaunch: onLaunch,
                        onTogglePin: onTogglePin,
                        onIndex: onIndex,
                        onScrollTop: { onJump(StartMenuMetrics.recentSectionKey) }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .scrollTargetLayout()
        }
        .frame(height: height)
        .animation(KbMotion.standard, value: height)
        .animation(KbMotion.standard, value: isShowingIndex)
        .overlay(alignment: .trailing) {
            StartMenuRailSlot(
                isShowing: showsRail,
                availableKeys: availableKeys,
                showsRecent: !recents.isEmpty,
                onJump: onJump
            )
        }
        .safeAreaBar(edge: .top) {
            StartMenuHeader(
                grouping: catalogue.grouping,
                layout: catalogue.layout,
                onSearch: onSearch,
                onGrouping: { catalogue.choose($0) },
                onLayout: { catalogue.choose($0) }
            )
        }
        .safeAreaBar(edge: .bottom) {
            StartMenuPowerBar(userName: userName, avatar: avatar, onPower: onPower)
                .padding(.horizontal, KbSpacing.s6)
                .padding(.top, KbSpacing.s5)
                .padding(.bottom, KbSpacing.s5 + KbPopoverMetrics.arrowSize.height)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(.regular.interactive(), in: Rectangle())
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    private var recents: [InstalledApplication] {
        usage.recents(among: catalogue.applications)
    }
}
