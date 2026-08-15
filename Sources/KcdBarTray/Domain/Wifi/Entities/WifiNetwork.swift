import Foundation

struct WifiNetwork: Equatable, Sendable, Identifiable {
    let ssid: String
    let rssi: Int
    let isSecure: Bool
    let isKnown: Bool
    let isCurrent: Bool

    var id: String { ssid }
}
