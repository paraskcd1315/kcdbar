import SwiftUI

enum KbMotion {
    static let curve: (x1: Float, y1: Float, x2: Float, y2: Float) = (0.32, 0.72, 0, 1)
    static let quickDuration: TimeInterval = 0.18
    static let standardDuration: TimeInterval = 0.28
    static let slowDuration: TimeInterval = 0.42

    static let quick = Animation.timingCurve(
        Double(curve.x1), Double(curve.y1), Double(curve.x2), Double(curve.y2),
        duration: quickDuration
    )
    static let standard = Animation.timingCurve(
        Double(curve.x1), Double(curve.y1), Double(curve.x2), Double(curve.y2),
        duration: standardDuration
    )
    static let slow = Animation.timingCurve(
        Double(curve.x1), Double(curve.y1), Double(curve.x2), Double(curve.y2),
        duration: slowDuration
    )
}
