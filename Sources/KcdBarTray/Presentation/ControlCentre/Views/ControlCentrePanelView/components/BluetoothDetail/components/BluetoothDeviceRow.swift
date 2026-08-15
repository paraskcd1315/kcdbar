import KcdBarDesignSystem
import SwiftUI

package struct BluetoothDeviceRow: View {
    package let device: BluetoothDevice

    package var body: some View {
        HStack(spacing: KbSpacing.s4) {
            Image(systemName: BluetoothStyle.symbol(for: device.kind))
                .font(.system(size: BluetoothMetrics.rowGlyphSize * KbControlCentreMetrics.glyphRatio))
                .foregroundStyle(device.isConnected ? KbColors.onBrand : KbColors.onSurface)
                .frame(width: BluetoothMetrics.rowGlyphSize, height: BluetoothMetrics.rowGlyphSize)
                .background(
                    Circle().fill(device.isConnected ? KbColors.brand : KbColors.surfaceRaised)
                )
            Text(device.name)
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
            Spacer(minLength: KbSpacing.s4)
        }
        .padding(.horizontal, KbSpacing.s4)
        .frame(height: BluetoothMetrics.rowHeight)
    }
}
