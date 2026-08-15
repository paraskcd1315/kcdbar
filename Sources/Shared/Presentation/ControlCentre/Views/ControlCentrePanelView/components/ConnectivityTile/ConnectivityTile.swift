import SwiftUI

struct ConnectivityTile: View {
    let wifi: WifiMonitor
    let onExpandWifi: () -> Void

    var body: some View {
        KbTile {
            WifiControlRow(state: wifi.state, onExpand: onExpandWifi)
        }
    }
}
