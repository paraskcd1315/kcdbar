import SwiftUI

struct WifiNearbyList: View {
    let monitor: WifiMonitor

    var body: some View {
        if monitor.isScanning && monitor.nearby.isEmpty {
            note("wifi.scanning")
        } else if monitor.nearby.isEmpty {
            note("wifi.none")
        } else {
            ForEach(monitor.nearby) { WifiNetworkRow(network: $0) }
        }
    }

    private func note(_ key: LocalizedStringKey) -> some View {
        Text(key)
            .font(KbTypography.tileStatus)
            .foregroundStyle(KbColors.onSurfaceMuted)
            .padding(.horizontal, KbSpacing.s4)
            .padding(.vertical, KbSpacing.s2)
    }
}
