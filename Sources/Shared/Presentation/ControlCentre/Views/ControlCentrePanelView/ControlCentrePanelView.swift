import SwiftUI

struct ControlCentrePanelView: View {
    let wifi: WifiMonitor
    let arrowX: CGFloat
    let presentation: PopoverPresentation
    let onOpenSettings: () -> Void

    @State private var isWifiExpanded = false

    var body: some View {
        GlassEffectContainer {
            panel
        }
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }

    private var panel: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            if isWifiExpanded {
                WifiDetail(monitor: wifi, onOpenSettings: onOpenSettings)
            } else {
                WifiTile(state: wifi.state) { expandWifi() }
            }
        }
        .padding(KbSpacing.s4)
        .padding(.bottom, KbPopoverMetrics.arrowSize.height)
        .frame(width: isWifiExpanded ? WifiMetrics.detailWidth : WifiMetrics.tileWidth, alignment: .leading)
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: arrowX))
        .overlay { KbPopoverEdge(arrowX: arrowX) }
        .animation(KbMotion.standard, value: isWifiExpanded)
    }

    private func expandWifi() {
        withAnimation(KbMotion.standard) { isWifiExpanded = true }
    }
}
