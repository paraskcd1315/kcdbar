import SwiftUI

struct ControlCentreTiles: View {
    let wifi: WifiMonitor
    let onExpandWifi: () -> Void

    var body: some View {
        VStack(spacing: KbControlCentreMetrics.tileGap) {
            ConnectivityTile(wifi: wifi, onExpandWifi: onExpandWifi)
        }
    }
}
