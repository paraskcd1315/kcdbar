import SwiftUI

package struct KbSliderTrack: View {
    package let value: Double
    package let height: CGFloat
    package let onChange: (Double) -> Void

    package var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(KbColors.sliderTrack)
                Capsule()
                    .fill(KbColors.sliderFill)
                    .frame(width: proxy.size.width * clamped)
            }
            .contentShape(Rectangle())
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
