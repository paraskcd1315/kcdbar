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
import SwiftUI

package struct SoundTile: View {
    package let monitor: SoundMonitor

    package var body: some View {
        KbTile {
            VStack(alignment: .leading, spacing: KbSpacing.s4) {
                Text("sound.title")
                    .font(KbTypography.tileTitle)
                    .foregroundStyle(KbColors.onSurface)
                KbSlider(
                    value: monitor.state.isMuted ? 0 : monitor.state.volume,
                    leadingSymbol: SoundMetrics.symbol(
                        volume: monitor.state.volume,
                        isMuted: monitor.state.isMuted
                    ),
                    trailingSymbol: SoundMetrics.loudSymbol,
                    onChange: { monitor.setVolume($0) },
                    onTapLeading: { monitor.toggleMuted() }
                )
            }
            .padding(.horizontal, KbSpacing.s3)
            .padding(.vertical, KbSpacing.s2)
        }
    }
}
