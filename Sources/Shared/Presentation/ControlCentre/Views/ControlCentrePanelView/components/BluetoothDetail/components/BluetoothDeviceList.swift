import SwiftUI

struct BluetoothDeviceList: View {
    let devices: [BluetoothDevice]

    var body: some View {
        if devices.isEmpty {
            Text("bluetooth.none")
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .padding(.horizontal, KbSpacing.s4)
                .padding(.vertical, KbSpacing.s2)
        } else {
            ForEach(devices) { BluetoothDeviceRow(device: $0) }
        }
    }
}
