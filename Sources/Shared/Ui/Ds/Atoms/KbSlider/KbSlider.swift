import SwiftUI

/** A capsule slider carrying its own glyph, in the shape macOS uses for display and sound. */
struct KbSlider: View {
    let value: Double
    let symbol: String
    var height: CGFloat = KbSliderMetrics.height
    let onChange: (Double) -> Void
    let onTapGlyph: () -> Void

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(KbColors.sliderTrack)
                Capsule()
                    .fill(KbColors.sliderFill)
                    .frame(width: max(proxy.size.width * clamped, height))
                Image(systemName: symbol)
                    .font(.system(size: height * KbSliderMetrics.glyphRatio))
                    .foregroundStyle(KbColors.sliderGlyph)
                    .frame(width: height, height: height)
                    .contentShape(Circle())
                    .onTapGesture(perform: onTapGlyph)
            }
            .contentShape(Capsule())
            .gesture(
                DragGesture(minimumDistance: 0).onChanged { drag in
                    onChange(min(max(drag.location.x / proxy.size.width, 0), 1))
                }
            )
        }
        .frame(height: height)
    }

    private var clamped: Double {
        min(max(value, 0), 1)
    }
}
