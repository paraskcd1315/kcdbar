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

package enum PowerActionMetrics {
    package static let loginWindowBundleIdentifier = "com.apple.loginwindow"
    package static let eventTimeout: TimeInterval = 10
    package static let sleepEvent = "slep"
    package static let showRestartDialogEvent = "rrst"
    package static let showShutdownDialogEvent = "rsdn"
    package static let logOutEvent = "logo"
    package static let loginFrameworkPath =
        "/System/Library/PrivateFrameworks/login.framework/Versions/A/login"
    package static let lockScreenSymbol = "SACLockScreenImmediate"
}
