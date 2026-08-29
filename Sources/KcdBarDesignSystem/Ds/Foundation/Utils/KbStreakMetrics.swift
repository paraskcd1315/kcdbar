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

/** Every number the working glow is drawn from. */
package enum KbStreakMetrics {
    package static let tick: Double = 1.0 / 30
    package static let corner: CGFloat = KbRadii.md
    package static let rimWidth: CGFloat = 96
    package static let rimBlur: CGFloat = 64

    package static let barRimWidth: CGFloat = 22
    package static let barRimBlur: CGFloat = 14

    package static let arcLead: CGFloat = 0.34
    package static let arcPeak: CGFloat = 0.5
    package static let arcTrail: CGFloat = 0.66

    package static let fullTurn: Double = 360
    package static let wave: Double = .pi * 2

    package static let lapOrange: Double = 11
    package static let lapPurple: Double = -14
    package static let lapPink: Double = 9
    package static let lapFuchsia: Double = -17

    package static let phaseOrange: Double = 0
    package static let phasePurple: Double = 0.28
    package static let phasePink: Double = 0.55
    package static let phaseFuchsia: Double = 0.79

    package static let breathOrange: Double = 6.5
    package static let breathPurple: Double = 8.2
    package static let breathPink: Double = 5.4
    package static let breathFuchsia: Double = 9.6

    package static let breathMid: Double = 0.3
    package static let breathSwing: Double = 0.14

    package static let entryScale: CGFloat = 1.08

    package static let loudBrighter: Double = 1.9
    package static let loudQuicker: Double = 0.45
}
