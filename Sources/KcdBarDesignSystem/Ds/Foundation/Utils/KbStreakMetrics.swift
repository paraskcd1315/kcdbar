import CoreGraphics
import Foundation

/** Every number the working glow is drawn from. */
package enum KbStreakMetrics {
    package static let corner: CGFloat = KbRadii.md
    package static let rimWidth: CGFloat = 14
    package static let rimBlur: CGFloat = 9

    package static let arcLead: CGFloat = 0.34
    package static let arcPeak: CGFloat = 0.5
    package static let arcTrail: CGFloat = 0.66

    package static let fullTurn: Double = 360

    package static let laps: [Double] = [11, -14, 9, -17]
    package static let phases: [Double] = [0, 0.28, 0.55, 0.79]
    package static let breaths: [Double] = [6.5, 8.2, 5.4, 9.6]

    package static let breathLow: Double = 0.16
    package static let breathHigh: Double = 0.44

    package static let waitingBrighter: Double = 1.9
    package static let waitingQuicker: Double = 0.45

    package static let entryScale: CGFloat = 1.08
}
