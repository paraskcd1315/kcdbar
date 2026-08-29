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

package struct StartMenuAppGrid: View {
    package let applications: [InstalledApplication]
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID?
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void

    package var body: some View {
        LazyVGrid(columns: columns, spacing: KbSpacing.s3) {
            ForEach(applications) { application in
                StartMenuAppTile(
                    application: application,
                    icon: icons.icon(forBundleIdentifier: application.bundleIdentifier),
                    iconNamespace: iconNamespace,
                    isPinned: pinnedIdentifiers.contains(application.bundleIdentifier),
                    onLaunch: { onLaunch(application.bundleIdentifier) },
                    onTogglePin: { onTogglePin(application.bundleIdentifier) }
                )
            }
        }
        .padding(.horizontal, KbSpacing.s5)
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: KbSpacing.s3),
            count: StartMenuMetrics.gridColumns
        )
    }
}
