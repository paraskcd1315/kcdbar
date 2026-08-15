import SwiftUI

struct WifiDetail: View {
    let monitor: WifiMonitor
    @Binding var showsOtherNetworks: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s4) {
            HStack {
                Text("wifi.title")
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.onSurface)
                Spacer(minLength: KbSpacing.s5)
                WifiToggle(isOn: monitor.state.isPowered) { monitor.setPower($0) }
            }
            if monitor.state.isPowered {
                networks
            }
        }
    }

    @ViewBuilder
    private var networks: some View {
        if !monitor.known.isEmpty {
            WifiSectionHeading(titleKey: "wifi.section.known")
            ForEach(monitor.known) { WifiNetworkRow(network: $0) }
        }
        WifiOtherNetworksSection(monitor: monitor, isExpanded: $showsOtherNetworks)
    }
}
