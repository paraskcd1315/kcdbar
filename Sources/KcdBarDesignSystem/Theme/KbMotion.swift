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

import SwiftUI

package enum KbMotion {
    package static let curve: (x1: Float, y1: Float, x2: Float, y2: Float) = (0.32, 0.72, 0, 1)
    package static let quickDuration: TimeInterval = 0.18
    package static let standardDuration: TimeInterval = 0.28
    package static let slowDuration: TimeInterval = 0.42

    package static let quick = Animation.timingCurve(
        Double(curve.x1), Double(curve.y1), Double(curve.x2), Double(curve.y2),
        duration: quickDuration
    )
    package static let standard = Animation.timingCurve(
        Double(curve.x1), Double(curve.y1), Double(curve.x2), Double(curve.y2),
        duration: standardDuration
    )
    package static let slow = Animation.timingCurve(
        Double(curve.x1), Double(curve.y1), Double(curve.x2), Double(curve.y2),
        duration: slowDuration
    )
}
