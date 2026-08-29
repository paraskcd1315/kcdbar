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

package struct StartMenuControls: View {
    package let grouping: StartMenuGrouping
    package let layout: StartMenuLayout
    package let onGrouping: (StartMenuGrouping) -> Void
    package let onLayout: (StartMenuLayout) -> Void

    package var body: some View {
        HStack(spacing: KbSpacing.s4) {
            KbSegmentedControl(
                segments: StartMenuGrouping.allCases.map {
                    KbSegment(value: $0, titleKey: LocalizedStringKey($0.titleKey))
                },
                selection: grouping,
                onSelect: onGrouping
            )
            KbSegmentedControl(
                segments: StartMenuLayout.allCases.map { KbSegment(value: $0, glyph: $0.glyph) },
                selection: layout,
                onSelect: onLayout
            )
            .fixedSize(horizontal: true, vertical: false)
        }
        .animation(KbMotion.standard, value: grouping)
        .animation(KbMotion.standard, value: layout)
    }
}
