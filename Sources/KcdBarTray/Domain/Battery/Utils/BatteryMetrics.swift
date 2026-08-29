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

package enum BatteryMetrics {
    package static let fullCharge = 100.0
    package static let skeletonWidths: [CGFloat] = [118, 92, 134]

    package static let criticalPercentage = 10
    package static let warningPercentage = 25
    package static let fullPercentage = 100

    package static let pillWidth: CGFloat = 25
    package static let pillHeight: CGFloat = 12
    package static let pillRadius: CGFloat = 3.5
    package static let capWidth: CGFloat = 2
    package static let capHeight: CGFloat = 5
    package static let capGap: CGFloat = 1.5
    package static let pillBorderWidth: CGFloat = 1
    package static let minimumFill: CGFloat = 0.06

    package static let significantEnergyImpact = 20.0
    package static let significantEnergyLimit = 5
    package static let sampleInterval: TimeInterval = 60
    package static let panelWidth: CGFloat = 300
    package static let panelGap: CGFloat = 6
    package static let arrowSize = CGSize(width: 18, height: 9)
    package static let dividerHeight: CGFloat = 1
    package static let collapsedScale: CGFloat = 0.55
    package static let collapseMilliseconds = 280
}
