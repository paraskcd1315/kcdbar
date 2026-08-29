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

import Foundation
import SwiftUI

/** One arc of light on the rim at one moment; the clock that moves it belongs to the stack. */
package struct KbStreakRibbon: View {
    package let colour: Color
    package let date: Date
    package let lapSeconds: Double
    package let phase: Double
    package let breathSeconds: Double
    package var corner: CGFloat = KbStreakMetrics.corner
    package var rimWidth: CGFloat = KbStreakMetrics.rimWidth
    package var rimBlur: CGFloat = KbStreakMetrics.rimBlur
    package var brightness: Double = 1

    package init(
        colour: Color,
        date: Date,
        lapSeconds: Double,
        phase: Double,
        breathSeconds: Double,
        corner: CGFloat = KbStreakMetrics.corner,
        rimWidth: CGFloat = KbStreakMetrics.rimWidth,
        rimBlur: CGFloat = KbStreakMetrics.rimBlur,
        brightness: Double = 1
    ) {
        self.colour = colour
        self.date = date
        self.lapSeconds = lapSeconds
        self.phase = phase
        self.breathSeconds = breathSeconds
        self.corner = corner
        self.rimWidth = rimWidth
        self.rimBlur = rimBlur
        self.brightness = brightness
    }

    package var body: some View {
        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .strokeBorder(sweep(at: date), lineWidth: rimWidth)
            .blur(radius: rimBlur)
            .opacity(breath(at: date))
            .allowsHitTesting(false)
    }

    private func sweep(at date: Date) -> AngularGradient {
        AngularGradient(
            stops: [
                .init(color: colour.opacity(0), location: 0),
                .init(color: colour.opacity(0), location: KbStreakMetrics.arcLead),
                .init(color: colour, location: KbStreakMetrics.arcPeak),
                .init(color: colour.opacity(0), location: KbStreakMetrics.arcTrail),
                .init(color: colour.opacity(0), location: 1),
            ],
            center: .center,
            angle: .degrees(turn(at: date) * KbStreakMetrics.fullTurn))
    }

    private func turn(at date: Date) -> Double {
        let laps = date.timeIntervalSinceReferenceDate / lapSeconds

        return (laps + phase).truncatingRemainder(dividingBy: 1)
    }

    private func breath(at date: Date) -> Double {
        let angle = date.timeIntervalSinceReferenceDate / breathSeconds + phase
        let swung =
            KbStreakMetrics.breathMid
            + KbStreakMetrics.breathSwing * sin(angle * KbStreakMetrics.wave)

        return min(1, swung * brightness)
    }
}
