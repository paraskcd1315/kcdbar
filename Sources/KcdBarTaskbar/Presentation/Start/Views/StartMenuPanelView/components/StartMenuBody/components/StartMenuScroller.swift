import KcdBarDesignSystem
import SwiftUI

package struct StartMenuScroller: View {
    package let catalogue: ApplicationCatalogueState
    package let icons: any ApplicationIconPort
    package let pinnedIdentifiers: Set<String>
    package let userName: String
    package let avatar: Image?
    package let height: CGFloat
    package let showsRail: Bool
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
            LazyVStack(alignment: .leading, spacing: KbSpacing.s5) {
                StartMenuAppList(
                    catalogue: catalogue,
                    pinnedIdentifiers: pinnedIdentifiers,
                    icons: icons,
                    iconNamespace: iconNamespace,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin,
                    onIndex: onIndex
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .scrollTargetLayout()
        }
        .frame(height: height)
        .animation(KbMotion.standard, value: height)
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
}
