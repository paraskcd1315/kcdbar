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

import KcdBarTray
import SwiftUI

/** Builds the Start menu's content, so no AppKit host constructs a view. */
@MainActor
package enum StartMenuPresentation {
    package static func content(
        catalogue: ApplicationCatalogueState,
        usage: ApplicationUsageState,
        pinned: PinnedAppState,
        groups: StartGroupState,
        editor: any PanelTextEditingPort,
        icons: any ApplicationIconPort,
        userName: String,
        avatar: Image?,
        presentation: PopoverPresentation,
        arrowX: CGFloat,
        onLaunch: @escaping (String) -> Void,
        onTogglePin: @escaping (String) -> Void,
        onPower: @escaping (StartPowerAction) -> Void,
        onSearch: @escaping () -> Void
    ) -> AnyView {
        AnyView(
            StartMenuPanelView(
                catalogue: catalogue,
                usage: usage,
                pinned: pinned,
                groups: groups,
                editor: editor,
                icons: icons,
                userName: userName,
                avatar: avatar,
                arrowX: arrowX,
                presentation: presentation,
                onLaunch: onLaunch,
                onTogglePin: onTogglePin,
                onPower: onPower,
                onSearch: onSearch
            )
        )
    }
}
