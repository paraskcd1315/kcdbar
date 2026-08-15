import SwiftUI

struct ControlCentrePanelView: View {
    let wifi: WifiMonitor
    let presentation: PopoverPresentation
    let onOpenSettings: () -> Void

    @State private var isWifiExpanded = false

    var body: some View {
        GlassEffectContainer {
            ControlCentreSurface(
                wifi: wifi,
                isWifiExpanded: $isWifiExpanded,
                onOpenSettings: onOpenSettings
            )
        }
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }
}
