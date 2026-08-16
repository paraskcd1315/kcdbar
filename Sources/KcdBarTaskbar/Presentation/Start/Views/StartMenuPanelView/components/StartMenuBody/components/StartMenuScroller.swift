import KcdBarDesignSystem
import SwiftUI

package struct StartMenuScroller: View {
    package let catalogue: ApplicationCatalogueState
    package let pinned: PinnedAppState
    package let icons: any ApplicationIconPort
    package let userName: String
    package let height: CGFloat
    package let showsRail: Bool
    package let availableKeys: Set<String>
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onPower: (StartPowerAction) -> Void
    package let onSearch: () -> Void
    package let onIndex: () -> Void
    package let onJump: (String) -> Void

    package var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: KbSpacing.s5) {
                StartMenuPinnedBand(
                    pinned: pinned,
                    icons: icons,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin
                )
                StartMenuAppList(
                    catalogue: catalogue,
                    pinnedIdentifiers: Set(pinned.apps.map(\.bundleIdentifier)),
                    icons: icons,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .frame(height: height)
        .overlay(alignment: .trailing) {
            StartMenuRailSlot(
                isShowing: showsRail,
                availableKeys: availableKeys,
                onJump: onJump
            )
        }
        .safeAreaBar(edge: .top) {
            StartMenuHeader(
                grouping: catalogue.grouping,
                layout: catalogue.layout,
                showsIndexButton: showsRail,
                onSearch: onSearch,
                onGrouping: { catalogue.choose($0) },
                onLayout: { catalogue.choose($0) },
                onIndex: onIndex
            )
        }
        .safeAreaBar(edge: .bottom) {
            StartMenuPowerBar(userName: userName, onPower: onPower)
                .padding(.horizontal, KbSpacing.s6)
                .padding(.top, KbSpacing.s5)
                .padding(.bottom, KbSpacing.s5 + KbPopoverMetrics.arrowSize.height)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(.regular.interactive(), in: Rectangle())
        }
        .scrollBounceBehavior(.basedOnSize)
    }
}
