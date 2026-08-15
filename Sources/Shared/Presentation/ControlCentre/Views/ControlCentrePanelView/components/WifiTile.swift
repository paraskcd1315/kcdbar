import SwiftUI

struct WifiTile: View {
    let monitor: WifiMonitor
    let onExpand: () -> Void

    var body: some View {
        KbTile {
            ConnectivityRow(
                symbol: WifiStyle.symbol(for: monitor.state),
                titleKey: "wifi.title",
                statusKey: ConnectivityLabels.wifiStatus(monitor.state),
                isOn: monitor.state.isPowered,
                onToggle: { monitor.setPower(!monitor.state.isPowered) },
                onOpen: onExpand
            )
        }
    }
}
