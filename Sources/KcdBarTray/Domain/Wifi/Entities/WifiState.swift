import Foundation

package struct WifiState: Equatable, Sendable {
    package let isAvailable: Bool
    package let isPowered: Bool
    package let ssid: String?
    package let rssi: Int

    package static let unavailable = WifiState(isAvailable: false, isPowered: false, ssid: nil, rssi: 0)
}
