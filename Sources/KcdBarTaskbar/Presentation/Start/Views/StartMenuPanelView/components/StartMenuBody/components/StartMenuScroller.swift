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
                    onScrollTop: { onJump(StartMenuMetrics.topAnchorKey) }
                )
                .opacity(isShowingIndex ? 0 : 1)
                .allowsHitTesting(!isShowingIndex)
                if isShowingIndex {
                    StartMenuLetterGrid(
                        keys: ApplicationIndexKeys.all,
                        available: availableKeys,
                        onSelect: onJump
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
                onGrouping: {
                    catalogue.choose($0)
                    onJump(StartMenuMetrics.topAnchorKey)
                },
                onLayout: {
                    catalogue.choose($0)
                    onJump(StartMenuMetrics.topAnchorKey)
                }
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
