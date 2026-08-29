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

package struct ControlCentreTiles: View {
    package let wifi: WifiMonitor
    package let bluetooth: BluetoothMonitor
    package let sound: SoundMonitor
    package let brightness: BrightnessMonitor
    package let onOpen: (ControlCentrePage) -> Void

    package var body: some View {
        GlassEffectContainer(spacing: KbControlCentreMetrics.tileGap) {
            VStack(spacing: KbControlCentreMetrics.tileGap) {
                SoundTile(monitor: sound)
                if brightness.state.isAvailable {
                    BrightnessTile(monitor: brightness)
                }
                HStack(alignment: .top, spacing: KbControlCentreMetrics.tileGap) {
                    if case let .ethernet(name) = wifi.link {
                        EthernetTile(name: name) { onOpen(.ethernet) }
                    } else {
                        WifiTile(monitor: wifi) { onOpen(.wifi) }
                    }
                    BluetoothTile(monitor: bluetooth) { onOpen(.bluetooth) }
                }
            }
        }
    }
}
