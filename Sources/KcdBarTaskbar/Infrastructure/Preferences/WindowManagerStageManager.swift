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

package struct WindowManagerStageManager: StageManagerPort {
    package init() {}

    package var isEnabled: Bool {
        let held = CFPreferencesCopyValue(
            StageManagerKeys.globallyEnabled as CFString,
            StageManagerKeys.domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )

        return (held as? Bool) ?? (held as? NSNumber)?.boolValue ?? false
    }

    package func setEnabled(_ enabled: Bool) {
        CFPreferencesSetValue(
            StageManagerKeys.globallyEnabled as CFString,
            enabled as CFBoolean,
            StageManagerKeys.domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )
        CFPreferencesSynchronize(
            StageManagerKeys.domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )
        DistributedNotificationCenter.default().postNotificationName(
            Notification.Name(StageManagerKeys.changeNotification),
            object: nil,
            userInfo: nil,
            deliverImmediately: true
        )
    }
}
