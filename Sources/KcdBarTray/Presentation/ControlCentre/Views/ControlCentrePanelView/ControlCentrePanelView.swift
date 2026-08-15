import KcdBarDesignSystem
import SwiftUI

package struct ControlCentrePanelView: View {
    package let wifi: WifiMonitor
    package let bluetooth: BluetoothMonitor
    package let sound: SoundMonitor
    package let brightness: BrightnessMonitor
    package let presentation: PopoverPresentation
    package let onOpenWifiSettings: () -> Void
    package let onOpenBluetoothSettings: () -> Void
    package let onOpenNetworkSettings: () -> Void
    package let onCopy: (String) -> Void

    @State private var page: ControlCentrePage = .tiles

    package init(
        wifi: WifiMonitor,
        bluetooth: BluetoothMonitor,
        sound: SoundMonitor,
        brightness: BrightnessMonitor,
        presentation: PopoverPresentation,
        onOpenWifiSettings: @escaping () -> Void,
        onOpenBluetoothSettings: @escaping () -> Void,
        onOpenNetworkSettings: @escaping () -> Void,
        onCopy: @escaping (String) -> Void
    ) {
        self.wifi = wifi
        self.bluetooth = bluetooth
        self.sound = sound
        self.brightness = brightness
        self.presentation = presentation
        self.onOpenWifiSettings = onOpenWifiSettings
        self.onOpenBluetoothSettings = onOpenBluetoothSettings
        self.onOpenNetworkSettings = onOpenNetworkSettings
        self.onCopy = onCopy
    }

    package var body: some View {
        ControlCentreSurface(
            wifi: wifi,
            bluetooth: bluetooth,
            sound: sound,
            brightness: brightness,
            page: $page,
            onOpenWifiSettings: onOpenWifiSettings,
            onOpenBluetoothSettings: onOpenBluetoothSettings,
            onOpenNetworkSettings: onOpenNetworkSettings,
            onCopy: onCopy
        )
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }
}
