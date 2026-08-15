import KcdBarDesignSystem
import SwiftUI

package struct ControlCentrePanelView: View {
    package let wifi: WifiMonitor
    package let bluetooth: BluetoothMonitor
    package let sound: SoundMonitor
    package let brightness: BrightnessMonitor
    package let presentation: PopoverPresentation
    package let onOpenSettings: () -> Void

    @State private var isWifiExpanded = false

    package var body: some View {
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
