import SwiftUI

struct WifiNearbyList: View {
    let monitor: WifiMonitor

    var body: some View {
        if monitor.isScanning && monitor.nearby.isEmpty {
            WifiNote(titleKey: "wifi.scanning")
        } else if monitor.nearby.isEmpty {
            WifiNote(titleKey: "wifi.none")
        } else {
            ForEach(monitor.nearby) { WifiNetworkRow(network: $0) }
        }
    }
}
