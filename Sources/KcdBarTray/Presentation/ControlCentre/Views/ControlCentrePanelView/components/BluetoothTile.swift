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

package struct BluetoothTile: View {
    package let monitor: BluetoothMonitor
    package let onExpand: () -> Void

    package init(monitor: BluetoothMonitor, onExpand: @escaping () -> Void) {
        self.monitor = monitor
        self.onExpand = onExpand
    }

    package var body: some View {
        KbTile {
            ConnectivityRow(
                titleKey: "bluetooth.title",
                statusKey: ConnectivityLabels.bluetoothStatus(monitor.state),
                isOn: monitor.state.isPowered,
                onToggle: { monitor.setPower(!monitor.state.isPowered) },
                onOpen: onExpand
            ) {
                KbBluetoothMark(
                    size: KbControlCentreMetrics.rowGlyphSize * KbControlCentreMetrics.glyphRatio
                )
            }
        }
    }
}
