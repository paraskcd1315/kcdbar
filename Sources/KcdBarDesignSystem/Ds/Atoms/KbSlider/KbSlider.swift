import SwiftUI

/** A thin track flanked by a small and a large glyph, in the shape macOS uses for display and sound. */
struct KbSlider: View {
    let value: Double
    let leadingSymbol: String
    let trailingSymbol: String
    var trackHeight: CGFloat = KbSliderMetrics.trackHeight
    let onChange: (Double) -> Void
    let onTapLeading: () -> Void

    var body: some View {
        HStack(spacing: KbSpacing.s4) {
            Image(systemName: leadingSymbol)
                .font(.system(size: KbSliderMetrics.leadingGlyphSize))
                .foregroundStyle(KbColors.onSurfaceMuted)
                .frame(width: KbSliderMetrics.leadingGlyphSize)
                .contentShape(Rectangle())
                .onTapGesture(perform: onTapLeading)
            KbSliderTrack(value: value, height: trackHeight, onChange: onChange)
            Image(systemName: trailingSymbol)
                .font(.system(size: KbSliderMetrics.trailingGlyphSize))
                .foregroundStyle(KbColors.onSurfaceMuted)
                .frame(width: KbSliderMetrics.trailingGlyphSize)
        }
    }
}
