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
            .task {
                proxy.scrollTo(StartMenuMetrics.topAnchorKey, anchor: .top)
            }
            .onAppear {
                proxy.scrollTo(StartMenuMetrics.topAnchorKey, anchor: .top)
            }
            .onDisappear {
                proxy.scrollTo(StartMenuMetrics.topAnchorKey, anchor: .top)
            }
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
