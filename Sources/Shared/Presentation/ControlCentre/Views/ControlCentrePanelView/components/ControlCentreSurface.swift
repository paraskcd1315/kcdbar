import SwiftUI

struct ControlCentreSurface: View {
    let wifi: WifiMonitor
    @Binding var isWifiExpanded: Bool
    let onOpenSettings: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s4) {
            if isWifiExpanded {
                WifiDetail(monitor: wifi, onOpenSettings: onOpenSettings)
            } else {
                ControlCentreTiles(wifi: wifi) {
                    withAnimation(KbMotion.standard) { isWifiExpanded = true }
                }
            }
        }
        .padding(KbControlCentreMetrics.panelPadding)
        .frame(width: KbControlCentreMetrics.panelWidth, alignment: .leading)
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: nil))
        .overlay { KbPopoverEdge(arrowX: nil) }
        .animation(KbMotion.standard, value: isWifiExpanded)
    }
}
