import KcdBarDesignSystem
import SwiftUI

package struct StartMenuSections: View {
    package let catalogue: ApplicationCatalogueState
    package let usage: ApplicationUsageState
    package let recents: [InstalledApplication]
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID
    package let recentNamespace: Namespace.ID
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onIndex: () -> Void
    package let onScrollTop: () -> Void

    package var body: some View {
        LazyVStack(
            alignment: .leading,
            spacing: KbSpacing.s5,
            pinnedViews: [.sectionHeaders]
        ) {
            Color.clear
                .frame(height: 0)
                .id(StartMenuMetrics.topAnchorKey)
            if !recents.isEmpty {
                Section {
                    if !usage.isRecentCollapsed {
                        StartMenuRecents(
                            applications: recents,
                            layout: catalogue.layout,
                            pinnedIdentifiers: pinnedIdentifiers,
                            icons: icons,
                            iconNamespace: recentNamespace,
                            onLaunch: onLaunch,
                            onTogglePin: onTogglePin
                        )
                    }
                } header: {
                    StartMenuStickyBar(
                        titleKey: "start.recent",
                        glyph: StartMenuMetrics.recentGlyph,
                        isCollapsed: usage.isRecentCollapsed,
                        onToggle: {
                            usage.isRecentCollapsed.toggle()
                            onScrollTop()
                        }
                    )
                    .id(StartMenuMetrics.recentSectionKey)
                    .onAppear(perform: onScrollTop)
                }
            }
            Section {
                StartMenuAppList(
                    catalogue: catalogue,
                    pinnedIdentifiers: pinnedIdentifiers,
                    icons: icons,
                    iconNamespace: iconNamespace,
                    onLaunch: onLaunch,
                    onTogglePin: onTogglePin,
                    onIndex: onIndex
                )
            } header: {
                StartMenuStickyBar(titleKey: "start.all", glyph: nil)
                    .id(StartMenuMetrics.allSectionKey)
            }
        }
        .animation(KbMotion.standard, value: usage.isRecentCollapsed)
    }
}
