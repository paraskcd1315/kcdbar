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

/** The loginwindow event each power action sends. */
package enum PowerAppleEvent {
    package static func identifier(for action: StartPowerAction) -> AEEventID? {
        switch action {
        case .sleep: code(PowerActionMetrics.sleepEvent)
        case .restart: code(PowerActionMetrics.showRestartDialogEvent)
        case .shutDown: code(PowerActionMetrics.showShutdownDialogEvent)
        case .logOut: code(PowerActionMetrics.logOutEvent)
        case .lock: nil
        }
    }

    package static func code(_ text: String) -> AEEventID {
        text.utf8.reduce(0) { AEEventID($0) << 8 | AEEventID($1) }
    }
}
