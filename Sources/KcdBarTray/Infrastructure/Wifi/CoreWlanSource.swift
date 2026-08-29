// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import CoreLocation
import CoreWLAN
import Foundation

@MainActor
package final class CoreWlanSource: NSObject, WifiPort {
    private let client = CWWiFiClient.shared()
    private let location = CLLocationManager()

    package func state() -> WifiState {
        guard let interface = client.interface() else { return .unavailable }

        return WifiState(
            isAvailable: true,
            isPowered: interface.powerOn(),
            ssid: interface.ssid(),
            rssi: interface.rssiValue()
        )
    }

    package func setPower(_ isOn: Bool) -> Bool {
        guard let interface = client.interface() else { return false }

        do {
            try interface.setPower(isOn)
            return true
        } catch {
            return false
        }
    }

    package func knownNetworks() -> [WifiNetwork] {
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

    package func scan() async -> [WifiNetwork] {
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

        let candidates = found.compactMap { network -> WifiNetwork? in
            guard let ssid = network.ssid, !ssid.isEmpty else { return nil }

            return WifiNetwork(
                ssid: ssid,
                rssi: network.rssiValue,
                isSecure: network.supportsSecurity(.personal) || network.supportsSecurity(.enterprise),
                isKnown: known.contains(ssid),
                isCurrent: ssid == current
            )
        }

        return WifiScanReducer.strongestPerSsid(candidates)
    }

    private func requestLocationIfNeeded() {
        guard location.authorizationStatus == .notDetermined else { return }

        location.requestWhenInUseAuthorization()
    }
}
