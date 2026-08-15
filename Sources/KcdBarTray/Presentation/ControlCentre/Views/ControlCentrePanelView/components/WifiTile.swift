import KcdBarDesignSystem
import SwiftUI

package struct WifiTile: View {
    package let monitor: WifiMonitor
    package let onExpand: () -> Void

    package init(monitor: WifiMonitor, onExpand: @escaping () -> Void) {
        self.monitor = monitor
        self.onExpand = onExpand
    }

    package var body: some View {
        KbTile {
            ConnectivityRow(
                titleKey: "wifi.title",
                statusKey: ConnectivityLabels.wifiStatus(monitor.state),
                isOn: monitor.state.isPowered,
                onToggle: { monitor.setPower(!monitor.state.isPowered) },
                onOpen: onExpand
            ) {
                Image(
                    systemName: WifiStyle.symbol(for: monitor.state),
                    variableValue: WifiStyle.level(for: monitor.state)
                )
                    .font(
                        .system(
                            size: KbControlCentreMetrics.rowGlyphSize
                                * KbControlCentreMetrics.glyphRatio
                        )
                    )
            }
        }
    }
}
