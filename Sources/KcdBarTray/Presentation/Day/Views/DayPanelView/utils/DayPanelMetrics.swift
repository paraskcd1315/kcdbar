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
import KcdBarDesignSystem

package enum DayPanelMetrics {
    package static let panelWidth: CGFloat = 300
    package static let rulerWidth: CGFloat = 34
    package static let hourHeight: CGFloat = 30
    package static let hoursInDay = 24
    package static let gridHeight = hourHeight * CGFloat(hoursInDay)
    package static let gridMaxHeight: CGFloat = 300
    package static let blockGutter: CGFloat = 4
    package static let blockInset: CGFloat = 1
    package static let blockMinHeight: CGFloat = 13
    package static let blockRadius: CGFloat = 4
    package static let blockTint: Double = 0.42
    package static let blockEdge: Double = 0.85
    package static let blockPadding: CGFloat = 3
    package static let projectFloor: CGFloat = 28
    package static let rangeFloor: CGFloat = 46
    package static let ruleHeight: CGFloat = 1
    package static let halfHourOpacity: Double = 0.45
    package static let nowDotSide: CGFloat = 5
    package static let nowLeadHours = 1
    package static let tick: Double = 1
    package static let billableSymbol = "creditcard"
    package static let openSymbol = "arrow.up.forward.app"
    package static let glyphSide: CGFloat = 8

    package static var blockArea: CGFloat {
        panelWidth - KbSpacing.s6 * 2 - rulerWidth - blockGutter
    }
}
