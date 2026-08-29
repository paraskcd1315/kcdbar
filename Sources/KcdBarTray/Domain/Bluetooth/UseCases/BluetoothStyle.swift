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

package enum BluetoothStyle {
    package static func symbol(for kind: BluetoothDeviceKind) -> String {
        switch kind {
        case .audio: BluetoothMetrics.audioSymbol
        case .phone: BluetoothMetrics.phoneSymbol
        case .computer: BluetoothMetrics.computerSymbol
        case .keyboard: BluetoothMetrics.keyboardSymbol
        case .pointing: BluetoothMetrics.pointingSymbol
        case .wearable: BluetoothMetrics.wearableSymbol
        case .other: BluetoothMetrics.otherSymbol
        }
    }

    package static func ordered(_ devices: [BluetoothDevice]) -> [BluetoothDevice] {
        devices.sorted { first, second in
            guard first.isConnected == second.isConnected else { return first.isConnected }

            return first.name.localizedCaseInsensitiveCompare(second.name) == .orderedAscending
        }
    }
}
