import SwiftUI

struct WifiTile: View {
    let monitor: WifiMonitor
    let onExpand: () -> Void

    var body: some View {
        KbTile {
            ConnectivityRow(
                titleKey: "wifi.title",
                statusKey: ConnectivityLabels.wifiStatus(monitor.state),
                isOn: monitor.state.isPowered,
                onToggle: { monitor.setPower(!monitor.state.isPowered) },
                onOpen: onExpand
            ) {
                Image(systemName: WifiStyle.symbol(for: monitor.state))
                    .font(
                        .system(
                            size: KbControlCentreMetrics.rowGlyphSize
                                * KbControlCentreMetrics.glyphRatio
                        )
                    )
            }
        }
    }
}
