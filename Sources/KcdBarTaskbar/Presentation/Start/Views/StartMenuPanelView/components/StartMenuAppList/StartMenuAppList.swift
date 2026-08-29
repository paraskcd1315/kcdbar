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

package struct StartMenuAppList: View {
    package let catalogue: ApplicationCatalogueState
    package let pinnedIdentifiers: Set<String>
    package let icons: any ApplicationIconPort
    package let iconNamespace: Namespace.ID
    package let onLaunch: (String) -> Void
    package let onTogglePin: (String) -> Void
    package let onIndex: () -> Void
    package let onScrollTop: () -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: StartMenuMetrics.sectionSpacing) {
            StartMenuOpenedHeading(
                opened: catalogue.openedSection,
                onBack: {
                    catalogue.closeCategory()
                    onScrollTop()
                }
            )
            StartMenuCatalogueContent(
                catalogue: catalogue,
                pinnedIdentifiers: pinnedIdentifiers,
                icons: icons,
                iconNamespace: iconNamespace,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onOpenCategory: {
                    catalogue.open(category: $0)
                    onScrollTop()
                },
                onIndex: onIndex
            )
        }
    }
}
