/** One SSID broadcast by several access points arrives several times; keep the strongest. */
package enum WifiScanReducer {
    package static func strongestPerSsid(_ networks: [WifiNetwork]) -> [WifiNetwork] {
        var strongest: [String: WifiNetwork] = [:]
        for network in networks where !network.ssid.isEmpty {
            if let held = strongest[network.ssid], held.rssi >= network.rssi { continue }

            strongest[network.ssid] = network
        }

        return Array(strongest.values)
    }
}
