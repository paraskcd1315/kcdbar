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

import SwiftUI

package struct StartMenuFolderMiniGrid: View {
    package let applications: [InstalledApplication]
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID

    package var body: some View {
        LazyVGrid(columns: columns, spacing: StartMenuMetrics.rowSpacing) {
            ForEach(applications.prefix(StartMenuMetrics.folderPreviewCount)) { application in
                StartMenuAppIcon(
                    icon: icons.icon(forBundleIdentifier: application.bundleIdentifier),
                    size: StartMenuMetrics.folderMiniIconSize
                )
                .matchedGeometryEffect(id: application.bundleIdentifier, in: iconNamespace)
            }
        }
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.fixed(StartMenuMetrics.folderMiniIconSize), spacing: StartMenuMetrics.rowSpacing),
            count: StartMenuMetrics.folderFaceColumns
        )
    }
}
