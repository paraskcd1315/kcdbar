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

/** The rim of light a surface wears while an agent is working. */
package struct KbWorkingStreaks: ViewModifier {
    package let isWorking: Bool
    package var isLoud: Bool = false
    package var corner: CGFloat = KbStreakMetrics.corner
    package var rimWidth: CGFloat = KbStreakMetrics.rimWidth
    package var rimBlur: CGFloat = KbStreakMetrics.rimBlur

    package func body(content: Content) -> some View {
        content.overlay {
            ZStack {
                if isWorking {
                    TimelineView(.periodic(from: .now, by: KbStreakMetrics.tick)) { clock in
                        ZStack {
                            ribbon(
                                KbStreakColours.orange,
                                at: clock.date,
                                lap: KbStreakMetrics.lapOrange,
                                phase: KbStreakMetrics.phaseOrange,
                                breath: KbStreakMetrics.breathOrange)

                            ribbon(
                                KbStreakColours.purple,
                                at: clock.date,
                                lap: KbStreakMetrics.lapPurple,
                                phase: KbStreakMetrics.phasePurple,
                                breath: KbStreakMetrics.breathPurple)

                            ribbon(
                                KbStreakColours.pink,
                                at: clock.date,
                                lap: KbStreakMetrics.lapPink,
                                phase: KbStreakMetrics.phasePink,
                                breath: KbStreakMetrics.breathPink)

                            ribbon(
                                KbStreakColours.fuchsia,
                                at: clock.date,
                                lap: KbStreakMetrics.lapFuchsia,
                                phase: KbStreakMetrics.phaseFuchsia,
                                breath: KbStreakMetrics.breathFuchsia)
                        }
                        .drawingGroup()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
                    .transition(
                        .opacity.combined(with: .scale(scale: KbStreakMetrics.entryScale)))
                }
            }
            .animation(KbMotion.slow, value: isWorking)
            .allowsHitTesting(false)
        }
    }

    private func ribbon(
        _ colour: Color, at date: Date, lap: Double, phase: Double, breath: Double
    ) -> KbStreakRibbon {
        KbStreakRibbon(
            colour: colour,
            date: date,
            lapSeconds: isLoud ? lap * KbStreakMetrics.loudQuicker : lap,
            phase: phase,
            breathSeconds: isLoud ? breath * KbStreakMetrics.loudQuicker : breath,
            corner: corner,
            rimWidth: rimWidth,
            rimBlur: rimBlur,
            brightness: isLoud ? KbStreakMetrics.loudBrighter : 1)
    }
}

extension View {
    /** Wears the working rim, louder where something is waiting on the person. */
    package func kbWorkingStreaks(
        _ isWorking: Bool,
        isLoud: Bool = false,
        corner: CGFloat = KbStreakMetrics.corner,
        rimWidth: CGFloat = KbStreakMetrics.rimWidth,
        rimBlur: CGFloat = KbStreakMetrics.rimBlur
    ) -> some View {
        modifier(
            KbWorkingStreaks(
                isWorking: isWorking, isLoud: isLoud, corner: corner, rimWidth: rimWidth,
                rimBlur: rimBlur))
    }
}
