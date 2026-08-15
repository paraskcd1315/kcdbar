import Foundation

struct BatteryState: Equatable, Sendable {
    let isPresent: Bool
    let percentage: Int
    let isCharging: Bool
    let isCharged: Bool
    let isPluggedIn: Bool
    let isLowPower: Bool
    let minutesRemaining: Int?

    static let absent = BatteryState(
        isPresent: false,
        percentage: 0,
        isCharging: false,
        isCharged: false,
        isPluggedIn: false,
        isLowPower: false,
        minutesRemaining: nil
    )
}
