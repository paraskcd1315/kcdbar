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

struct TaskbarEntryFullScreenTests {
    private func entry(fullScreen: [Bool]) -> TaskbarEntryModel {
        TaskbarEntryModel(
            id: "app", title: "App", applicationName: "App", bundleIdentifier: "com.example.app",
            icon: nil, isMinimized: false, isFrontmost: false, isPinned: false, isLauncher: false,
            isRunning: true, instanceCount: fullScreen.count, instancesOnThisDisplay: fullScreen.count,
            previewWindows: fullScreen.enumerated().map { index, flag in
                TaskbarPreviewWindow(id: CGWindowID(index + 1), size: CGSize(width: 800, height: 600), isFullScreen: flag)
            })
    }

    @Test func theCountIsTheFullScreenWindowsAmongThePreviews() {
        #expect(entry(fullScreen: [false, false]).fullScreenCount == 0)
        #expect(entry(fullScreen: [true, false]).fullScreenCount == 1)
        #expect(entry(fullScreen: [true, true, false]).fullScreenCount == 2)
    }

    @Test func anEntryIsFullScreenWhenAnyWindowIs() {
        #expect(entry(fullScreen: [false, true]).isFullScreen)
        #expect(!entry(fullScreen: [false]).isFullScreen)
    }
}
