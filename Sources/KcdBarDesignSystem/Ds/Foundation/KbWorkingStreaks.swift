import SwiftUI

/** The rim of light a surface wears while an agent is working. */
package struct KbWorkingStreaks: ViewModifier {
    package let isWorking: Bool
    package var isLoud: Bool = false
    package var corner: CGFloat = KbStreakMetrics.corner
    package var rimWidth: CGFloat = KbStreakMetrics.rimWidth
    package var rimBlur: CGFloat = KbStreakMetrics.rimBlur

    package func body(content: Content) -> some View {
        content.overlay {
            ZStack {
                if isWorking {
                    ZStack {
                        ForEach(Array(colours.enumerated()), id: \.offset) { held in
                            KbStreakRibbon(
                                colour: held.element,
                                lapSeconds: lap(at: held.offset),
                                breathSeconds: breath(at: held.offset),
                                corner: corner,
                                rimWidth: rimWidth,
                                rimBlur: rimBlur,
                                brightness: brightness)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
                    .transition(
                        .opacity.combined(with: .scale(scale: KbStreakMetrics.entryScale)))
                }
            }
            .animation(KbMotion.standard, value: isWorking)
            .allowsHitTesting(false)
        }
    }

    private var colours: [Color] {
        isLoud ? Array(repeating: KbStreakColours.waiting, count: KbStreakColours.every.count)
            : KbStreakColours.every
    }

    private var brightness: Double { isLoud ? KbStreakMetrics.waitingBrighter : 1 }

    private func lap(at index: Int) -> Double {
        let stated = KbStreakMetrics.laps[index % KbStreakMetrics.laps.count]

        return isLoud ? stated * KbStreakMetrics.waitingQuicker : stated
    }

    private func breath(at index: Int) -> Double {
        let stated = KbStreakMetrics.breaths[index % KbStreakMetrics.breaths.count]

        return isLoud ? stated * KbStreakMetrics.waitingQuicker : stated
    }
}

extension View {
    /** Wears the working rim, louder where something is waiting on the person. */
    package func kbWorkingStreaks(
        _ isWorking: Bool,
        isLoud: Bool = false,
        corner: CGFloat = KbStreakMetrics.corner,
        rimWidth: CGFloat = KbStreakMetrics.rimWidth,
        rimBlur: CGFloat = KbStreakMetrics.rimBlur
    ) -> some View {
        modifier(
            KbWorkingStreaks(
                isWorking: isWorking, isLoud: isLoud, corner: corner, rimWidth: rimWidth,
                rimBlur: rimBlur))
    }
}
