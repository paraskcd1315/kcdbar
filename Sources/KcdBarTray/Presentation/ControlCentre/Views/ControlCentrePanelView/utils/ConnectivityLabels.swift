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
