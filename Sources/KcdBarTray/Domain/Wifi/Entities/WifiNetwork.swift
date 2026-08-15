import Foundation

package struct WifiNetwork: Equatable, Sendable, Identifiable {
    package let ssid: String
    package let rssi: Int
    package let isSecure: Bool
    package let isKnown: Bool
    package let isCurrent: Bool

    package var id: String { ssid }
}
