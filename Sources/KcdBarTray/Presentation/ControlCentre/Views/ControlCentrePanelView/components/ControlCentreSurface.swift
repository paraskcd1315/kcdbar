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

package struct ControlCentreSurface: View {
    package let wifi: WifiMonitor
    package let bluetooth: BluetoothMonitor
    package let sound: SoundMonitor
    package let brightness: BrightnessMonitor
    @Binding package var page: ControlCentrePage
    package let onOpenWifiSettings: () -> Void
    package let onOpenBluetoothSettings: () -> Void
    package let onOpenNetworkSettings: () -> Void
    package let onCopy: (String) -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbControlCentreMetrics.tileGap) {
            switch page {
            case .tiles:
                ControlCentreTiles(
                    wifi: wifi,
                    bluetooth: bluetooth,
                    sound: sound,
                    brightness: brightness,
                    onOpen: { show($0) }
                )
            case .wifi:
                KbTile {
                    WifiDetail(
                        monitor: wifi,
                        onBack: { show(.tiles) },
                        onCopy: onCopy,
                        onOpenSettings: onOpenWifiSettings
                    )
                }
            case .ethernet:
                KbTile {
                    EthernetDetail(
                        name: ethernetName,
                        detail: wifi.detail,
                        onBack: { show(.tiles) },
                        onCopy: onCopy,
                        onOpenSettings: onOpenNetworkSettings
                    )
                }
            case .bluetooth:
                KbTile {
                    BluetoothDetail(
                        monitor: bluetooth,
                        onBack: { show(.tiles) },
                        onOpenSettings: onOpenBluetoothSettings
                    )
                }
            }
        }
        .padding(KbControlCentreMetrics.panelPadding)
        .frame(width: KbControlCentreMetrics.panelWidth, alignment: .leading)
        .animation(KbMotion.standard, value: page)
    }

    private var ethernetName: String {
        if case let .ethernet(name) = wifi.link { return name }

        return ""
    }

    private func show(_ wanted: ControlCentrePage) {
        withAnimation(KbMotion.standard) { page = wanted }
    }
}
