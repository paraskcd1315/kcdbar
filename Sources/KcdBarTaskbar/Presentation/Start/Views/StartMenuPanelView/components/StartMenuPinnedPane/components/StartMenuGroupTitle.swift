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

package struct StartMenuGroupTitle: View {
    package let group: StartGroup

    package var body: some View {
        Group {
            if let title = group.title {
                Text(title)
            } else if let titleKey = group.titleKey {
                Text(LocalizedStringKey(titleKey))
            } else {
                Text("start.group.untitled")
            }
        }
        .font(KbTypography.panelDetail)
        .foregroundStyle(KbColors.onSurfaceMuted)
        .lineLimit(1)
    }
}
