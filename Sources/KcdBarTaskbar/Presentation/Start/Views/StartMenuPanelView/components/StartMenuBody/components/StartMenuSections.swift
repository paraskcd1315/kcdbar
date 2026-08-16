import KcdBarDesignSystem
import SwiftUI

package struct StartMenuSections: View {
    package let catalogue: ApplicationCatalogueState
    package let usage: ApplicationUsageState
    package let recents: [InstalledApplication]
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onIndex: () -> Void

    package var body: some View {
        LazyVStack(
            alignment: .leading,
            spacing: KbSpacing.s5,
            pinnedViews: [.sectionHeaders]
        ) {
            if !recents.isEmpty {
                Section {
                    if !usage.isRecentCollapsed {
                        StartMenuRecentRows(
                            applications: recents,
                            pinnedIdentifiers: pinnedIdentifiers,
                            icons: icons,
                            onLaunch: onLaunch,
                            onTogglePin: onTogglePin
                        )
                    }
                } header: {
                    StartMenuStickyBar(
                        titleKey: "start.recent",
                        glyph: StartMenuMetrics.recentGlyph,
                        isCollapsed: usage.isRecentCollapsed,
                        onToggle: { usage.isRecentCollapsed.toggle() }
                    )
                    .id(StartMenuMetrics.recentSectionKey)
                }
            }
            Section {
                if !usage.isAllCollapsed {
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
            } header: {
                StartMenuStickyBar(
                    titleKey: "start.all",
                    glyph: nil,
                    isCollapsed: usage.isAllCollapsed,
                    onToggle: { usage.isAllCollapsed.toggle() }
                )
                .id(StartMenuMetrics.allSectionKey)
            }
        }
        .animation(KbMotion.standard, value: usage.isRecentCollapsed)
        .animation(KbMotion.standard, value: usage.isAllCollapsed)
    }
}
