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

package struct StartMenuHeader: View {
    package let grouping: StartMenuGrouping
    package let layout: StartMenuLayout
    package let onSearch: () -> Void
    package let onGrouping: (StartMenuGrouping) -> Void
    package let onLayout: (StartMenuLayout) -> Void

    package var body: some View {
        VStack(spacing: KbSpacing.s4) {
            StartMenuSearchField(onOpen: onSearch)
            StartMenuControls(
                grouping: grouping,
                layout: layout,
                onGrouping: onGrouping,
                onLayout: onLayout
            )
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.vertical, KbSpacing.s5)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular.interactive(), in: Rectangle())
    }
}
