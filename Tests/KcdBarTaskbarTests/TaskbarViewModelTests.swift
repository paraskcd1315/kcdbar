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

@MainActor
struct TaskbarViewModelTests {
    private let display = DisplayGeometry(
        id: 1,
        frame: CGRect(x: 0, y: 0, width: 1920, height: 1080),
        isPrimary: true
    )

    private func window(_ id: UInt32, pid: pid_t) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: pid, cgWindowId: id, fallbackKey: "\(pid):\(id)"),
            ownerPid: pid,
            ownerName: "App",
            title: "Window",
            bounds: CGRect(x: 10, y: 10, width: 800, height: 600),
            isMinimized: false,
            isFullScreen: false,
            isOnScreen: true,
            zOrder: 0,
            source: .both
        )
    }

    private func model(
        windows: [ManagedWindow],
        bundleIdentifiers: [pid_t: String],
        pinnedApps: [PinnedApp] = [],
        runningApplications: [RunningApplication] = []
    ) -> TaskbarViewModel {
        TaskbarViewModel(
            preset: BarPresetCatalogue.default,
            windows: windows,
            displayId: display.id,
            displays: [display],
            frontmostPid: nil,
            bundleIdentifiers: bundleIdentifiers,
            pinnedApps: pinnedApps,
            runningApplications: runningApplications,
            ranks: [:],
            hasAccessibility: true,
            icons: SilentApplicationIcons()
        )
    }

    @Test func aRunningApplicationWithNoWindowStillGetsAnEntry() {
        let viewModel = model(
            windows: [],
            bundleIdentifiers: [:],
            runningApplications: [
                RunningApplication(pid: 30, bundleIdentifier: "com.apple.Safari", localizedName: "Safari")
            ]
        )

        #expect(viewModel.entries.map(\.bundleIdentifier) == ["com.apple.Safari"])
        #expect(viewModel.entries.first?.isRunning == true)
        #expect(viewModel.entries.first?.instanceCount == 0)
    }

    @Test func anApplicationThatOwnsAWindowIsNotListedTwice() {
        let viewModel = model(
            windows: [window(10, pid: 30)],
            bundleIdentifiers: [30: "com.apple.Safari"],
            runningApplications: [
                RunningApplication(pid: 30, bundleIdentifier: "com.apple.Safari", localizedName: "Safari")
            ]
        )

        #expect(viewModel.entries.count == 1)
        #expect(viewModel.entries.first?.isLauncher == false)
    }

    @Test func aPinnedRunningApplicationKeepsItsPinnedEntry() {
        let viewModel = model(
            windows: [],
            bundleIdentifiers: [:],
            pinnedApps: [
                PinnedApp(bundleIdentifier: "com.apple.Safari", displayName: "Safari", order: 0)
            ],
            runningApplications: [
                RunningApplication(pid: 30, bundleIdentifier: "com.apple.Safari", localizedName: "Safari")
            ]
        )

        #expect(viewModel.entries.count == 1)
        #expect(viewModel.entries.first?.isPinned == true)
    }
}
