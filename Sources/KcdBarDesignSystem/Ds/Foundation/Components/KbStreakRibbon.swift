import Foundation
import SwiftUI

/** One arc of light riding the rim, breathing as it travels. */
package struct KbStreakRibbon: View {
    package let colour: Color
    package let lapSeconds: Double
    package let phase: Double
    package let breathSeconds: Double
    package var corner: CGFloat = KbStreakMetrics.corner
    package var rimWidth: CGFloat = KbStreakMetrics.rimWidth
    package var rimBlur: CGFloat = KbStreakMetrics.rimBlur
    package var brightness: Double = 1

    package init(
        colour: Color,
        lapSeconds: Double,
        phase: Double,
        breathSeconds: Double,
        corner: CGFloat = KbStreakMetrics.corner,
        rimWidth: CGFloat = KbStreakMetrics.rimWidth,
        rimBlur: CGFloat = KbStreakMetrics.rimBlur,
        brightness: Double = 1
    ) {
        self.colour = colour
        self.lapSeconds = lapSeconds
        self.phase = phase
        self.breathSeconds = breathSeconds
        self.corner = corner
        self.rimWidth = rimWidth
        self.rimBlur = rimBlur
        self.brightness = brightness
    }

    package var body: some View {
        TimelineView(.periodic(from: .now, by: KbStreakMetrics.tick)) { clock in
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .strokeBorder(sweep(at: clock.date), lineWidth: rimWidth)
                .blur(radius: rimBlur)
                .opacity(breath(at: clock.date))
        }
        .allowsHitTesting(false)
    }

    private func sweep(at date: Date) -> AngularGradient {
        AngularGradient(
            stops: [
                .init(color: colour.opacity(0), location: 0),
                .init(color: colour.opacity(0), location: KbStreakMetrics.arcLead),
                .init(color: colour, location: KbStreakMetrics.arcPeak),
                .init(color: colour.opacity(0), location: KbStreakMetrics.arcTrail),
                .init(color: colour.opacity(0), location: 1),
            ],
            center: .center,
            angle: .degrees(turn(at: date) * KbStreakMetrics.fullTurn))
    }

    private func turn(at date: Date) -> Double {
        let laps = date.timeIntervalSinceReferenceDate / lapSeconds

        return (laps + phase).truncatingRemainder(dividingBy: 1)
    }

    private func breath(at date: Date) -> Double {
        let angle = date.timeIntervalSinceReferenceDate / breathSeconds + phase
        let swung =
            KbStreakMetrics.breathMid
            + KbStreakMetrics.breathSwing * sin(angle * KbStreakMetrics.wave)

        return min(1, swung * brightness)
    }
}
