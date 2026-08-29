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

import SwiftUI

package struct TaskbarEntryMenu: View {
    package let entry: TaskbarEntryModel
    package let onTogglePin: () -> Void
    package let onCloseWindow: () -> Void
    package let onQuit: () -> Void

    package var body: some View {
        Button(action: onTogglePin) {
            Label(
                entry.isPinned ? "taskbar.menu.unpin" : "taskbar.menu.pin",
                systemImage: entry.isPinned
                    ? TaskbarMenuMetrics.unpinSymbol
                    : TaskbarMenuMetrics.pinSymbol
            )
        }
        if !entry.isLauncher {
            Divider()
            Button(action: onCloseWindow) {
                Label("taskbar.menu.close", systemImage: TaskbarMenuMetrics.closeSymbol)
            }
            .keyboardShortcut("w")
        }
        if entry.isRunning, ApplicationQuitPolicy.canQuit(bundleIdentifier: entry.bundleIdentifier) {
            Divider()
            Button(role: .destructive, action: onQuit) {
                Label("taskbar.menu.quit", systemImage: TaskbarMenuMetrics.quitSymbol)
            }
            .keyboardShortcut("q")
        }
    }
}
