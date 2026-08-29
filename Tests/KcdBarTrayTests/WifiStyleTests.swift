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

struct WifiStyleTests {
    private func state(available: Bool = true, powered: Bool = true, rssi: Int) -> WifiState {
        WifiState(isAvailable: available, isPowered: powered, ssid: "net", rssi: rssi)
    }

    @Test func theSlashOnlyMeansOff() {
        #expect(WifiStyle.symbol(for: state(powered: false, rssi: 0)) == WifiMetrics.slashSymbol)
        #expect(WifiStyle.symbol(for: state(available: false, rssi: 0)) == WifiMetrics.slashSymbol)
    }

    @Test func aPoweredRadioNeverDrawsTheSlash() {
        #expect(WifiStyle.symbol(for: state(rssi: 0)) == WifiMetrics.symbol)
        #expect(WifiStyle.symbol(for: state(rssi: -90)) == WifiMetrics.symbol)
        #expect(WifiStyle.symbol(for: state(rssi: -40)) == WifiMetrics.symbol)
    }

    @Test func theLevelFollowsTheSignal() {
        #expect(WifiStyle.level(rssi: -40) == 1)
        #expect(WifiStyle.level(rssi: -65) == WifiMetrics.fairLevel)
        #expect(WifiStyle.level(rssi: -75) == WifiMetrics.weakLevel)
        #expect(WifiStyle.level(rssi: -95) == WifiMetrics.faintLevel)
    }

    @Test func anUnmeasuredSignalReadsFullRatherThanEmpty() {
        #expect(WifiStyle.level(rssi: 0) == WifiMetrics.unknownLevel)
    }

    @Test func anUnpoweredRadioHasNoLevel() {
        #expect(WifiStyle.level(for: state(powered: false, rssi: -40)) == 0)
    }
}
