import SwiftUI

struct BluetoothDetail: View {
    let monitor: BluetoothMonitor
    let onBack: () -> Void
    let onOpenSettings: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            ControlCentreDetailHeader(
                titleKey: "bluetooth.title",
                isOn: monitor.state.isPowered,
                onBack: onBack,
                onSetPower: { monitor.setPower($0) }
            )
            if monitor.state.isPowered {
                BluetoothDeviceList(devices: monitor.devices)
            }
            ControlCentreSettingsRow(titleKey: "bluetooth.settings", onOpen: onOpenSettings)
        }
        .onAppear { monitor.refresh() }
    }
}
