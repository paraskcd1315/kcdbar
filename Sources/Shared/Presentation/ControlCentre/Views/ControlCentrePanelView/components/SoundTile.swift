import SwiftUI

struct SoundTile: View {
    let monitor: SoundMonitor

    var body: some View {
        KbTile {
            VStack(alignment: .leading, spacing: KbSpacing.s3) {
                Text("sound.title")
                    .font(KbTypography.tileTitle)
                    .foregroundStyle(KbColors.onSurface)
                KbSlider(
                    value: monitor.state.isMuted ? 0 : monitor.state.volume,
                    symbol: SoundMetrics.symbol(
                        volume: monitor.state.volume,
                        isMuted: monitor.state.isMuted
                    ),
                    onChange: { monitor.setVolume($0) },
                    onTapGlyph: { monitor.toggleMuted() }
                )
            }
            .padding(.horizontal, KbSpacing.s3)
            .padding(.vertical, KbSpacing.s2)
        }
    }
}
