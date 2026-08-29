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

@testable import KcdBarTaskbar

struct TaskbarEntryStackTests {
    private func entry(windows: Int) -> TaskbarEntryModel {
        TaskbarEntryModel(
            id: "app", title: "App", applicationName: "App", bundleIdentifier: "com.example.app",
            icon: nil, isMinimized: false, isFrontmost: false, isPinned: false, isLauncher: false,
            isRunning: true, instanceCount: windows, instancesOnThisDisplay: windows, previewWindows: [])
    }

    @Test func oneSheetPerExtraWindowUpToFour() {
        #expect(TaskbarEntryStyle.stackSheets(entry(windows: 1), grouping: .perApplication) == 0)
        #expect(TaskbarEntryStyle.stackSheets(entry(windows: 2), grouping: .perApplication) == 1)
        #expect(TaskbarEntryStyle.stackSheets(entry(windows: 5), grouping: .perApplication) == 4)
        #expect(TaskbarEntryStyle.stackSheets(entry(windows: 9), grouping: .perApplication) == 4)
    }

    @Test func perWindowGroupingStacksNothing() {
        #expect(TaskbarEntryStyle.stackSheets(entry(windows: 3), grouping: .perWindow) == 0)
    }
}
