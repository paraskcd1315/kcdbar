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
