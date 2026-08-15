import Foundation

package struct BatteryState: Equatable, Sendable {
    package let isPresent: Bool
    package let percentage: Int
    package let isCharging: Bool
    package let isCharged: Bool
    package let isPluggedIn: Bool
    package let isLowPower: Bool
    package let minutesRemaining: Int?

    package static let absent = BatteryState(
        isPresent: false,
        percentage: 0,
        isCharging: false,
        isCharged: false,
        isPluggedIn: false,
        isLowPower: false,
        minutesRemaining: nil
    )
}
