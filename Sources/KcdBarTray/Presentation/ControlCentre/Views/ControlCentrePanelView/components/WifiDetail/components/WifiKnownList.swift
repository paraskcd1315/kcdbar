import KcdBarDesignSystem
import SwiftUI

package struct WifiKnownList: View {
    package let networks: [WifiNetwork]

    package var body: some View {
        if !networks.isEmpty {
            Text("wifi.section.known")
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .padding(.horizontal, KbSpacing.s4)
            ForEach(networks) { WifiNetworkRow(network: $0) }
        }
    }
}
