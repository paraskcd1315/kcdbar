import KcdBarDesignSystem
import SwiftUI

package struct BluetoothDetail: View {
    package let monitor: BluetoothMonitor
    package let onBack: () -> Void
    package let onOpenSettings: () -> Void

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            ControlCentreDetailHeader(
                titleKey: "bluetooth.title",
                isOn: monitor.state.isPowered,
                onBack: onBack,
                onSetPower: { monitor.setPower($0) }
            )
            ControlCentreDetailBody {
                if monitor.state.isPowered {
                    BluetoothDeviceList(devices: monitor.devices)
                }
            }
            ControlCentreSettingsRow(titleKey: "bluetooth.settings", onOpen: onOpenSettings)
        }
        .onAppear { monitor.refresh() }
    }
}
