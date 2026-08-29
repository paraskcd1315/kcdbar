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

package enum ConnectivityLabels {
    package static func wifiStatus(_ state: WifiState) -> LocalizedStringKey {
        guard state.isAvailable else { return "wifi.status.unavailable" }
        guard state.isPowered else { return "wifi.status.off" }

        return state.ssid.map { LocalizedStringKey($0) } ?? "wifi.status.on"
    }

    package static func bluetoothStatus(_ state: BluetoothState) -> LocalizedStringKey {
        guard state.isAvailable else { return "bluetooth.status.unavailable" }

        return state.isPowered ? "bluetooth.status.on" : "bluetooth.status.off"
    }
}
