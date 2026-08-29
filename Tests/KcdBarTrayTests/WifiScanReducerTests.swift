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

import Testing
@testable import KcdBarTray

struct WifiScanReducerTests {
    private func network(_ ssid: String, _ rssi: Int) -> WifiNetwork {
        WifiNetwork(ssid: ssid, rssi: rssi, isSecure: true, isKnown: false, isCurrent: false)
    }

    @Test func oneSsidFromTwoAccessPointsKeepsTheStronger() {
        let reduced = WifiScanReducer.strongestPerSsid([
            network("mesh", -70),
            network("mesh", -45),
            network("mesh", -80),
        ])

        #expect(reduced.count == 1)
        #expect(reduced.first?.rssi == -45)
    }

    @Test func distinctSsidsAllSurvive() {
        let reduced = WifiScanReducer.strongestPerSsid([
            network("a", -50),
            network("b", -60),
        ])

        #expect(Set(reduced.map(\.ssid)) == ["a", "b"])
    }

    @Test func aHiddenNetworkWithNoNameIsDropped() {
        #expect(WifiScanReducer.strongestPerSsid([network("", -40)]).isEmpty)
    }
}
