import KcdBarDesignSystem
import SwiftUI

package struct StartMenuBody: View {
    package let catalogue: ApplicationCatalogueState
    package let pinned: PinnedAppState
    package let icons: any ApplicationIconPort
    package let userName: String
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onPower: (StartPowerAction) -> Void

    package var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: KbSpacing.s5) {
                if !pinned.apps.isEmpty {
                    StartMenuPinnedGrid(
                        pinned: pinned.apps,
                        icons: icons,
                        onLaunch: onLaunch,
                        onTogglePin: onTogglePin
                    )
                    StartMenuDivider()
                }
                StartMenuAppList(
                    catalogue: catalogue,
                    pinnedIdentifiers: pinnedIdentifiers,
                    icons: icons,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .frame(height: height)
        .safeAreaBar(edge: .top) {
            StartMenuSearchField()
                .padding(.horizontal, KbSpacing.s6)
                .padding(.vertical, KbSpacing.s5)
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

    private var pinnedIdentifiers: Set<String> {
        Set(pinned.apps.map(\.bundleIdentifier))
    }

    private var height: CGFloat {
        guard !catalogue.isLoading else {
            return StartMenuMetrics.bodyHeight(
                pinned: pinned.apps.count,
                rows: StartMenuMetrics.skeletonRowCount,
                sections: StartMenuMetrics.skeletonBandCount
            )
        }

        return StartMenuMetrics.bodyHeight(
            pinned: pinned.apps.count,
            rows: catalogue.applications.count,
            sections: catalogue.sections.count
        )
    }
}
