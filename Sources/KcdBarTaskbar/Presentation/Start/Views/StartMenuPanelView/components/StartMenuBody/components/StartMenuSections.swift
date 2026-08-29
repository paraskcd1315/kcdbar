// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
    package let onScrollTop: () -> Void

    package var body: some View {
        LazyVStack(
            alignment: .leading,
            spacing: 0,
            pinnedViews: [.sectionHeaders]
        ) {
            if !recents.isEmpty {
                Section {
                    if !usage.isRecentCollapsed {
                        StartMenuRecents(
                            applications: recents,
                            layout: catalogue.layout,
                            pinnedIdentifiers: pinnedIdentifiers,
                            icons: icons,
                            onLaunch: onLaunch,
                            onTogglePin: onTogglePin
                        )
                        .padding(.vertical, KbSpacing.s5)
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
                    onIndex: onIndex,
                    onScrollTop: onScrollTop
                )
                .padding(.top, KbSpacing.s5)
            } header: {
                StartMenuStickyBar(titleKey: "start.all", glyph: nil)
                    .id(StartMenuMetrics.allSectionKey)
            }
        }
        .overlay(alignment: .top) {
            Color.clear
                .frame(width: 0, height: 0)
                .id(StartMenuMetrics.topAnchorKey)
        }
        .animation(KbMotion.standard, value: usage.isRecentCollapsed)
    }
}
