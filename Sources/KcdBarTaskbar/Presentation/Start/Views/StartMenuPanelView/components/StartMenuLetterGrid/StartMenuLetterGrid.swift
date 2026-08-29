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

package struct StartMenuLetterGrid: View {
    package let keys: [String]
    package let available: Set<String>
    package let onSelect: (String) -> Void

    package var body: some View {
        LazyVGrid(columns: columns, spacing: KbSpacing.s3) {
            StartMenuLetterCell(
                key: StartMenuMetrics.topAnchorKey,
                glyph: StartMenuMetrics.recentGlyph,
                isAvailable: true,
                onSelect: { onSelect(StartMenuMetrics.topAnchorKey) }
            )
            ForEach(keys, id: \.self) { key in
                StartMenuLetterCell(
                    key: key,
                    isAvailable: available.contains(key),
                    onSelect: { onSelect(key) }
                )
            }
        }
        .padding(.horizontal, KbSpacing.s6)
        .padding(.vertical, KbSpacing.s5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: KbSpacing.s3),
            count: StartMenuMetrics.letterGridColumns
        )
    }
}
