import SwiftUI

struct BrightnessTile: View {
    let monitor: BrightnessMonitor

    var body: some View {
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
