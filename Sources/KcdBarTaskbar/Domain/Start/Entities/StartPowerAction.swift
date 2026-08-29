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

/** The power actions the Start menu offers. */
package enum StartPowerAction: String, CaseIterable, Sendable, Identifiable {
    case lock
    case sleep
    case restart
    case shutDown
    case logOut

    package var id: String { rawValue }

    package static var barActions: [StartPowerAction] { [.lock, .sleep, .restart, .shutDown] }

    package static var accountActions: [StartPowerAction] { [.lock, .logOut] }

    package var symbol: String {
        switch self {
        case .lock: "lock"
        case .sleep: "moon"
        case .restart: "arrow.clockwise"
        case .shutDown: "power"
        case .logOut: "rectangle.portrait.and.arrow.right"
        }
    }

    package var titleKey: String {
        switch self {
        case .lock: "start.power.lock"
        case .sleep: "start.power.sleep"
        case .restart: "start.power.restart"
        case .shutDown: "start.power.shutDown"
        case .logOut: "start.power.logOut"
        }
    }
}
