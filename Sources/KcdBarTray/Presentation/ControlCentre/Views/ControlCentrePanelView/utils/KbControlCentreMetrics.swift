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
import Foundation

package enum KbControlCentreMetrics {
    package static let glyphRatio: CGFloat = 0.55
    package static let hoverOpacity: Double = 0.10
    package static let selectedOpacity: Double = 0.16
    package static let toggleWidth: CGFloat = 42
    package static let toggleHeight: CGFloat = 24
    package static let listMaxHeight: CGFloat = 260
    package static let knobInset: CGFloat = 2.5
    package static let panelWidth: CGFloat = 340
    package static let panelPadding: CGFloat = 10
    package static let tileGap: CGFloat = 8
    package static let rowGlyphSize: CGFloat = 34
    package static let rowHeight: CGFloat = 38
    package static let detailLabelWidth: CGFloat = 108
    package static let copiedDuration: TimeInterval = 1.2
    package static let detailMaxHeight: CGFloat = 260
    package static let detailRowHeight: CGFloat = 30

    package static func listHeight(rows: Int, cap: CGFloat) -> CGFloat {
        min(CGFloat(max(rows, 1)) * detailRowHeight, cap)
    }
    package static let chevronSymbol = "chevron.right"
    package static let backSymbol = "chevron.left"
    package static let settingsRowHeight: CGFloat = 28
}
