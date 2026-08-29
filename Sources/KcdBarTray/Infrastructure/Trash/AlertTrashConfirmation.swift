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

import AppKit

/** Asks about emptying the trash in a window of its own, never inside the bar's panel. */
@MainActor
package final class AlertTrashConfirmation: TrashConfirmationPort {
    package init() {}

    package func confirmEmpty() -> Bool {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = String(localized: "trash.confirm.title")
        alert.informativeText = String(localized: "trash.confirm.message")
        alert.addButton(withTitle: String(localized: "trash.confirm.empty"))
        alert.addButton(withTitle: String(localized: "trash.confirm.cancel"))
        alert.buttons.first?.hasDestructiveAction = true
        alert.window.level = .popUpMenu

        NSApp.activate(ignoringOtherApps: true)
        let answer = alert.runModal()
        NSApp.deactivate()

        return answer == .alertFirstButtonReturn
    }
}
