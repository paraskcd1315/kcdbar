import KcdBarDesignSystem
import SwiftUI

package struct BrightnessTile: View {
    package let monitor: BrightnessMonitor

    package var body: some View {
        KbTile {
            VStack(alignment: .leading, spacing: KbSpacing.s4) {
                Text("display.title")
                    .font(KbTypography.tileTitle)
                    .foregroundStyle(KbColors.onSurface)
                KbSlider(
                    value: monitor.state.level,
                    leadingSymbol: BrightnessMetrics.lowSymbol,
                    trailingSymbol: BrightnessMetrics.highSymbol,
                    onChange: { monitor.setLevel($0) },
                    onTapLeading: {}
                )
            }
            .padding(.horizontal, KbSpacing.s3)
            .padding(.vertical, KbSpacing.s2)
        }
    }
}
