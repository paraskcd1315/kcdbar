import Foundation

package enum WifiStyle {
    /** The SF Symbol whose filled bars match the signal, as macOS draws it. */
    package static func symbol(for state: WifiState) -> String {
        guard state.isAvailable else { return WifiMetrics.slashSymbol }
        guard state.isPowered else { return WifiMetrics.slashSymbol }

        return WifiMetrics.symbol(bars: bars(rssi: state.rssi))
    }

    package static func symbol(for network: WifiNetwork) -> String {
        WifiMetrics.symbol(bars: bars(rssi: network.rssi))
    }

    package static func bars(rssi: Int) -> Int {
        guard rssi != 0 else { return 0 }
        if rssi >= WifiMetrics.strongRssi { return 3 }
        if rssi >= WifiMetrics.fairRssi { return 2 }
        if rssi >= WifiMetrics.weakRssi { return 1 }

        return 0
    }

    package static func ordered(_ networks: [WifiNetwork]) -> [WifiNetwork] {
        networks.sorted { first, second in
            guard first.isKnown == second.isKnown else { return first.isKnown }

            return first.rssi > second.rssi
        }
    }
}
