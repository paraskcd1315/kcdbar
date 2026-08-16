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
    package let onSearch: () -> Void

    @State private var isShowingIndex = false

    package var body: some View {
        ScrollViewReader { proxy in
            StartMenuScroller(
                catalogue: catalogue,
                pinned: pinned,
                icons: icons,
                userName: userName,
                height: height,
                showsRail: showsIndex,
                availableKeys: availableKeys,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower,
                onSearch: onSearch,
                onIndex: { isShowingIndex = true },
                onJump: { proxy.scrollTo($0, anchor: .top) }
            )
            .overlay {
                StartMenuIndexOverlay(
                    isShowing: isShowingIndex,
                    availableKeys: availableKeys,
                    onJump: { proxy.scrollTo($0, anchor: .top) },
                    onDismiss: { isShowingIndex = false }
                )
            }
        }
    }

    private var showsIndex: Bool {
        catalogue.grouping == .alphabetical && !catalogue.isLoading
    }

    private var availableKeys: Set<String> {
        Set(catalogue.sections.map(\.key))
    }

    private var height: CGFloat {
        guard !catalogue.isLoading else {
            return StartMenuMetrics.bodyHeight(
                pinned: pinned.apps.count,
                rows: StartMenuMetrics.skeletonRowCount,
                sections: StartMenuMetrics.skeletonBandCount
            )
        }
        let sections = catalogue.visibleSections
        guard !catalogue.showsFolders else {
            return min(
                StartMenuMetrics.pinnedHeight(pinned.apps.count)
                    + StartMenuMetrics.folderHeight(folders: sections.count),
                StartMenuMetrics.bodyMaxHeight
            )
        }
        guard catalogue.layout == .grid else {
            return StartMenuMetrics.bodyHeight(
                pinned: pinned.apps.count,
                rows: sections.reduce(0) { $0 + $1.applications.count },
                sections: sections.count
            )
        }

        return min(
            StartMenuMetrics.pinnedHeight(pinned.apps.count)
                + StartMenuMetrics.gridHeight(
                    lines: StartMenuMetrics.gridLines(of: sections),
                    sections: sections.count
                ),
            StartMenuMetrics.bodyMaxHeight
        )
    }
}
