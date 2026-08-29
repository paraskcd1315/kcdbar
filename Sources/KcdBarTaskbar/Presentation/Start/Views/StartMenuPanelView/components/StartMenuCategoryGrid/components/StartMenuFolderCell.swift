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

package struct StartMenuFolderCell: View {
    package let applications: [InstalledApplication]
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID

    package var body: some View {
        ZStack {
            if applications.count == 1, let only = applications.first {
                StartMenuAppIcon(
                    icon: icons.icon(forBundleIdentifier: only.bundleIdentifier),
                    size: StartMenuMetrics.folderIconSize
                )
                .matchedGeometryEffect(id: only.bundleIdentifier, in: iconNamespace)
            } else {
                StartMenuFolderMiniGrid(
                    applications: applications,
                    icons: icons,
                    iconNamespace: iconNamespace
                )
            }
        }
        .frame(
            width: StartMenuMetrics.folderIconSize,
            height: StartMenuMetrics.folderIconSize
        )
    }
}
