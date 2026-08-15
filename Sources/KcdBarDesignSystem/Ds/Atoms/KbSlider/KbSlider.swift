import SwiftUI

/** A thin track flanked by a small and a large glyph, in the shape macOS uses for display and sound. */
package struct KbSlider: View {
    package let value: Double
    package let leadingSymbol: String
    package let trailingSymbol: String
    package var trackHeight: CGFloat = KbSliderMetrics.trackHeight
    package let onChange: (Double) -> Void
    package let onTapLeading: () -> Void

    package init(
        value: Double,
        leadingSymbol: String,
        trailingSymbol: String,
        trackHeight: CGFloat = KbSliderMetrics.trackHeight,
        onChange: @escaping (Double) -> Void,
        onTapLeading: @escaping () -> Void
    ) {
        self.value = value
        self.leadingSymbol = leadingSymbol
        self.trailingSymbol = trailingSymbol
        self.trackHeight = trackHeight
        self.onChange = onChange
        self.onTapLeading = onTapLeading
    }

    package var body: some View {
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
