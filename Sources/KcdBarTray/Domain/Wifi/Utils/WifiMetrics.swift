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

package enum WifiMetrics {
    package static let strongRssi = -60
    package static let fairRssi = -70
    package static let weakRssi = -80

    package static let symbol = "wifi"
    package static let slashSymbol = "wifi.slash"

    package static let unknownLevel = 1.0
    package static let fairLevel = 0.66
    package static let weakLevel = 0.33
    package static let faintLevel = 0.1
    package static let lockSymbol = "lock.fill"
    package static let chevronSymbol = "chevron.right"

    package static let rowGlyphSize: CGFloat = 20
    package static let rescanInterval: TimeInterval = 20
    package static let rowHeight: CGFloat = 28
    package static let headerHeight: CGFloat = 26

    package static func listHeight(rows: Int, cap: CGFloat) -> CGFloat {
        min(CGFloat(rows) * rowHeight, cap)
    }
}
