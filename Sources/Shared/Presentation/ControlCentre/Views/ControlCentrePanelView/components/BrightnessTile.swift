import SwiftUI

struct BrightnessTile: View {
    let monitor: BrightnessMonitor

    var body: some View {
        KbTile {
            VStack(alignment: .leading, spacing: KbSpacing.s3) {
                Text("display.title")
                    .font(KbTypography.tileTitle)
                    .foregroundStyle(KbColors.onSurface)
                KbSlider(
                    value: monitor.state.level,
                    symbol: BrightnessMetrics.symbol,
                    onChange: { monitor.setLevel($0) },
                    onTapGlyph: {}
                )
            }
            .padding(.horizontal, KbSpacing.s3)
            .padding(.vertical, KbSpacing.s2)
        }
    }
}
