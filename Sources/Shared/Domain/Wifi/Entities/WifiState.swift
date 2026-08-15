import Foundation

struct WifiState: Equatable, Sendable {
    let isAvailable: Bool
    let isPowered: Bool
    let ssid: String?
    let rssi: Int

    static let unavailable = WifiState(isAvailable: false, isPowered: false, ssid: nil, rssi: 0)
}
