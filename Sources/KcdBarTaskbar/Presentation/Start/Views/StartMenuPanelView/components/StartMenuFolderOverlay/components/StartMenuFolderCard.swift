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

package struct StartMenuFolderCard: View {
    package let section: ApplicationSection
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s5) {
            Text(LocalizedStringKey(section.titleKey ?? section.key))
                .font(KbTypography.menuHeading)
                .foregroundStyle(KbColors.onSurface)
                .padding(.horizontal, KbSpacing.s6)
            ViewThatFits(in: .vertical) {
                grid
                ScrollView { grid }
                    .scrollIndicators(.never)
            }
        }
        .padding(.vertical, KbSpacing.s6)
        .frame(maxWidth: StartMenuMetrics.folderCardMaxWidth)
        .background(KbVibrancyBackdrop().clipShape(shape))
        .overlay(shape.strokeBorder(KbColors.separator, lineWidth: KbEdgeMetrics.width))
        .contentShape(shape)
    }

    private var grid: some View {
        StartMenuAppGrid(
            applications: section.applications,
            pinnedIdentifiers: pinnedIdentifiers,
            icons: icons,
            iconNamespace: nil,
            onLaunch: onLaunch,
            onTogglePin: onTogglePin
        )
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.xl, style: .continuous)
    }
}
