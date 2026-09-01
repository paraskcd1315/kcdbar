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

import CoreGraphics
import Testing

@testable import KcdBarTaskbar

struct TaskbarEntryCycleTests {
    private func entry(previewing ids: [CGWindowID]) -> TaskbarEntryModel {
        TaskbarEntryModel(
            id: "entry",
            title: "Console",
            applicationName: "Console",
            bundleIdentifier: "com.paraskcd.ccconsole",
            icon: nil,
            isMinimized: false,
            isFrontmost: false,
            isPinned: false,
            isLauncher: false,
            isRunning: true,
            instanceCount: ids.count,
            instancesOnThisDisplay: ids.count,
            previewWindows: ids.map {
                TaskbarPreviewWindow(id: $0, size: CGSize(width: 1920, height: 1030))
            }
        )
    }

    @Test func anEntryStandingForTwoWindowsCycles() {
        #expect(entry(previewing: [3785, 3632]).cyclesWindows)
    }

    @Test func anEntryStandingForOneWindowDoesNotCycle() {
        #expect(entry(previewing: [3785]).cyclesWindows == false)
    }

    @Test func anEntryStandingForNoWindowDoesNotCycle() {
        #expect(entry(previewing: []).cyclesWindows == false)
    }

    @Test func aGhostWindowLeavingTheModelStopsTheEntryCycling() {
        let both = entry(previewing: [3785, 3908])
        let real = entry(previewing: [3785])

        #expect(both.cyclesWindows)
        #expect(real.cyclesWindows == false)
    }
}
