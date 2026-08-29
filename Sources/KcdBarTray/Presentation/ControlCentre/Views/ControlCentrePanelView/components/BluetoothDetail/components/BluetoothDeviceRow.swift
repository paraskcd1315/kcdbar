// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
