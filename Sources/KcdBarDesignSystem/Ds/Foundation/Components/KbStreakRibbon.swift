import SwiftUI

/** One arc of light riding the rim, breathing as it travels. */
package struct KbStreakRibbon: View {
    package let colour: Color
    package let lapSeconds: Double
    package let breathSeconds: Double
    package let corner: CGFloat
    package let rimWidth: CGFloat
    package let rimBlur: CGFloat
    package let brightness: Double

    @State private var turned = false
    @State private var breathed = false

    package init(
        colour: Color,
        lapSeconds: Double,
        breathSeconds: Double,
        corner: CGFloat = KbStreakMetrics.corner,
        rimWidth: CGFloat = KbStreakMetrics.rimWidth,
        rimBlur: CGFloat = KbStreakMetrics.rimBlur,
        brightness: Double = 1
    ) {
        self.colour = colour
        self.lapSeconds = lapSeconds
        self.breathSeconds = breathSeconds
        self.corner = corner
        self.rimWidth = rimWidth
        self.rimBlur = rimBlur
        self.brightness = brightness
    }

    package var body: some View {
        RoundedRectangle(cornerRadius: corner, style: .continuous)
            .strokeBorder(sweep, lineWidth: rimWidth)
            .blur(radius: rimBlur)
            .rotationEffect(.degrees(turned ? KbStreakMetrics.fullTurn * direction : 0))
            .opacity(breathed ? high : low)
            .animation(
                .linear(duration: abs(lapSeconds)).repeatForever(autoreverses: false),
                value: turned
            )
            .animation(
                .easeInOut(duration: breathSeconds).repeatForever(autoreverses: true),
                value: breathed
            )
            .onAppear {
                turned = true
                breathed = true
            }
            .allowsHitTesting(false)
    }

    private var direction: Double { lapSeconds < 0 ? -1 : 1 }

    private var low: Double { min(1, KbStreakMetrics.breathLow * brightness) }

    private var high: Double { min(1, KbStreakMetrics.breathHigh * brightness) }

    private var sweep: AngularGradient {
        AngularGradient(
            stops: [
                .init(color: colour.opacity(0), location: 0),
                .init(color: colour.opacity(0), location: KbStreakMetrics.arcLead),
                .init(color: colour, location: KbStreakMetrics.arcPeak),
                .init(color: colour.opacity(0), location: KbStreakMetrics.arcTrail),
                .init(color: colour.opacity(0), location: 1),
            ],
            center: .center)
    }
}
