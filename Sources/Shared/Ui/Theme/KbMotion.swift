import SwiftUI

enum KbMotion {
    static let quick = Animation.timingCurve(0.32, 0.72, 0, 1, duration: 0.18)
    static let standard = Animation.timingCurve(0.32, 0.72, 0, 1, duration: 0.28)
    static let slow = Animation.timingCurve(0.32, 0.72, 0, 1, duration: 0.42)
}
