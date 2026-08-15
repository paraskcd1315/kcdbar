import SwiftUI

struct WifiKnownList: View {
    let networks: [WifiNetwork]

    var body: some View {
        if !networks.isEmpty {
            Text("wifi.section.known")
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .padding(.horizontal, KbSpacing.s4)
            ForEach(networks) { WifiNetworkRow(network: $0) }
        }
    }
}
