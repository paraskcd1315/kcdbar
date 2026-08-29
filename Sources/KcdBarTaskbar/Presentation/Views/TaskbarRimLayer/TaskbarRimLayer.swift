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
import KcdBarTray
import SwiftUI

/** The working rim, in a view graph of its own so its clock never reaches the bar's. */
package struct TaskbarRimLayer: View {
    package let presetState: BarPresetState
    package let frame: BarFrameState
    package let sessions: SessionsMonitor

    package init(presetState: BarPresetState, frame: BarFrameState, sessions: SessionsMonitor) {
        self.presetState = presetState
        self.frame = frame
        self.sessions = sessions
    }

    package var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear

            if let rect = TaskbarRimPlacement.rect(
                measured: frame.frame, attachment: presetState.preset.attachment)
            {
                Color.clear
                    .frame(width: rect.width, height: rect.height)
                    .kbWorkingStreaks(
                        sessions.reading.isWorking,
                        isLoud: sessions.reading.wantsAttention,
                        corner: presetState.preset.cornerRadius,
                        rimWidth: KbStreakMetrics.barRimWidth,
                        rimBlur: KbStreakMetrics.barRimBlur
                    )
                    .offset(x: rect.minX, y: rect.minY)
            }
        }
        .allowsHitTesting(false)
    }
}
