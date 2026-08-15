import CoreLocation
import CoreWLAN
import Foundation

@MainActor
final class CoreWlanSource: NSObject, WifiPort {
    private let client = CWWiFiClient.shared()
    private let location = CLLocationManager()

    func state() -> WifiState {
        guard let interface = client.interface() else { return .unavailable }

        return WifiState(
            isAvailable: true,
            isPowered: interface.powerOn(),
            ssid: interface.ssid(),
            rssi: interface.rssiValue()
        )
    }

    func setPower(_ isOn: Bool) -> Bool {
        guard let interface = client.interface() else { return false }

        do {
            try interface.setPower(isOn)
            return true
        } catch {
            return false
        }
    }

    func knownNetworks() -> [WifiNetwork] {
        guard let interface = client.interface(),
              let profiles = interface.configuration()?.networkProfiles.array as? [CWNetworkProfile]
        else {
            return []
        }
        let current = interface.ssid()

        return profiles.compactMap { profile in
            guard let ssid = profile.ssid else { return nil }

            return WifiNetwork(
                ssid: ssid,
                rssi: ssid == current ? interface.rssiValue() : 0,
                isSecure: profile.security != .none,
                isKnown: true,
                isCurrent: ssid == current
            )
        }
    }

    func scan() async -> [WifiNetwork] {
        requestLocationIfNeeded()
        guard client.interface() != nil else { return [] }

        let current = client.interface()?.ssid()
        let known = Set(knownNetworks().map(\.ssid))

        return await Task.detached(priority: .utility) {
            Self.sweep(known: known, current: current)
        }.value
    }

    /** Runs off the main actor: scanForNetworks blocks for seconds. */
    private nonisolated static func sweep(known: Set<String>, current: String?) -> [WifiNetwork] {
        guard let interface = CWWiFiClient.shared().interface(),
              let found = try? interface.scanForNetworks(withSSID: nil)
        else {
            return []
        }

        var strongest: [String: WifiNetwork] = [:]
        for network in found {
            guard let ssid = network.ssid, !ssid.isEmpty else { continue }

            let candidate = WifiNetwork(
                ssid: ssid,
                rssi: network.rssiValue,
                isSecure: network.supportsSecurity(.personal) || network.supportsSecurity(.enterprise),
                isKnown: known.contains(ssid),
                isCurrent: ssid == current
            )
            if let held = strongest[ssid], held.rssi >= candidate.rssi { continue }

            strongest[ssid] = candidate
        }

        return Array(strongest.values)
    }

    private func requestLocationIfNeeded() {
        guard location.authorizationStatus == .notDetermined else { return }

        location.requestWhenInUseAuthorization()
    }
}
