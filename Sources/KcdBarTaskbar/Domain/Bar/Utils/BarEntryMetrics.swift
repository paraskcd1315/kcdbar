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

import CoreGraphics

package enum BarEntryMetrics {
    package static let iconSize: CGFloat = 34
    package static let minimumIconSize: CGFloat = 12
    package static let iconBodyRatio: CGFloat = 0.81
    package static let markRatio: CGFloat = 0.76

    package static let inset: CGFloat = 6

    package static func iconSize(for preset: BarPreset) -> CGFloat {
        let available = preset.thickness - preset.contentPadding * 2

        return max(minimumIconSize, min(preset.iconSize, available))
    }

    package static func itemSide(for preset: BarPreset) -> CGFloat {
        guard preset.entryFit == .edgeToEdge else {
            return iconSize(for: preset) + inset * 2
        }
        return preset.thickness
    }
}
