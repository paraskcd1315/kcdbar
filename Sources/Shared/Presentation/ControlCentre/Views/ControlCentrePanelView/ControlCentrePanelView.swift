import SwiftUI

struct ControlCentrePanelView: View {
    let wifi: WifiMonitor
    let arrowX: CGFloat
    let presentation: PopoverPresentation

    @State private var isWifiExpanded = false
    @State private var showsOtherNetworks = false

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            if isWifiExpanded {
                WifiDetail(monitor: wifi, showsOtherNetworks: $showsOtherNetworks)
            } else {
                WifiTile(state: wifi.state) { expandWifi() }
            }
        }
        .padding(KbSpacing.s4)
        .padding(.bottom, KbPopoverMetrics.arrowSize.height)
        .frame(width: isWifiExpanded ? WifiMetrics.detailWidth : WifiMetrics.tileWidth, alignment: .leading)
        .glassEffect(.regular, in: KbPopoverShape(arrowX: arrowX))
        .animation(KbMotion.standard, value: isWifiExpanded)
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }

    private func expandWifi() {
        withAnimation(KbMotion.standard) { isWifiExpanded = true }
    }
}
