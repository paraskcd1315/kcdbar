import SwiftUI

struct ControlCentrePanelView: View {
    let wifi: WifiMonitor
    let bluetooth: BluetoothMonitor
    let sound: SoundMonitor
    let brightness: BrightnessMonitor
    let presentation: PopoverPresentation
    let onOpenSettings: () -> Void

    @State private var isWifiExpanded = false

    var body: some View {
        ControlCentreSurface(
            wifi: wifi,
            bluetooth: bluetooth,
            sound: sound,
            brightness: brightness,
            isWifiExpanded: $isWifiExpanded,
            onOpenSettings: onOpenSettings
        )
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }
}
