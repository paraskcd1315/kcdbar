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

package struct StartMenuCategoryFolder: View {
    package let section: ApplicationSection
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID
    package let onOpen: () -> Void

    @State private var isHovered = false

    package var body: some View {
        VStack(spacing: KbSpacing.s3) {
            LazyVGrid(columns: columns, spacing: StartMenuMetrics.folderInnerSpacing) {
                ForEach(Array(cells.enumerated()), id: \.offset) { _, cell in
                    StartMenuFolderCell(
                        applications: cell,
                        icons: icons,
                        iconNamespace: iconNamespace
                    )
                }
            }
            .padding(StartMenuMetrics.folderInnerSpacing)
            .frame(
                width: StartMenuMetrics.folderCardSize,
                height: StartMenuMetrics.folderCardSize
            )
            .background(
                KbColors.onSurface.opacity(
                    isHovered
                        ? StartMenuMetrics.hoverFillOpacity
                        : StartMenuMetrics.folderFillOpacity
                ),
                in: shape
            )
            .kbTappable(in: shape, perform: onOpen)
            Text(LocalizedStringKey(section.titleKey ?? section.key))
                .font(KbTypography.entryTitle)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
                .frame(height: StartMenuMetrics.folderLabelHeight)
        }
        .onHover { isHovered = $0 }
        .animation(KbMotion.quick, value: isHovered)
    }

    private var cells: [[InstalledApplication]] {
        ApplicationFolderPreview.cells(of: section.applications)
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: StartMenuMetrics.folderInnerSpacing),
            count: StartMenuMetrics.folderFaceColumns
        )
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.xl, style: .continuous)
    }
}
