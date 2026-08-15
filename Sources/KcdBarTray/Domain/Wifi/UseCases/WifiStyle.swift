import Foundation

package enum WifiStyle {
    /** The slash means the radio is off; a powered radio always draws the wifi glyph. */
    package static func symbol(for state: WifiState) -> String {
        guard state.isAvailable, state.isPowered else { return WifiMetrics.slashSymbol }

        return WifiMetrics.symbol
    }

    package static func symbol(for network: WifiNetwork) -> String {
        WifiMetrics.symbol
    }

    /** How many of the glyph's arcs are filled, as SF Symbols' variable value. */
    package static func level(for state: WifiState) -> Double {
        guard state.isAvailable, state.isPowered else { return 0 }

        return level(rssi: state.rssi)
    }

    package static func level(for network: WifiNetwork) -> Double {
        level(rssi: network.rssi)
    }

    package static func level(rssi: Int) -> Double {
        guard rssi != 0 else { return WifiMetrics.unknownLevel }
        if rssi >= WifiMetrics.strongRssi { return 1 }
        if rssi >= WifiMetrics.fairRssi { return WifiMetrics.fairLevel }
        if rssi >= WifiMetrics.weakRssi { return WifiMetrics.weakLevel }

        return WifiMetrics.faintLevel
    }

    package static func ordered(_ networks: [WifiNetwork]) -> [WifiNetwork] {
        networks.sorted { first, second in
            guard first.isKnown == second.isKnown else { return first.isKnown }

            return first.rssi > second.rssi
        }
    }
}
