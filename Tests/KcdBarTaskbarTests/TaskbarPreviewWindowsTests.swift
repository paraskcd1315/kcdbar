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

struct TaskbarPreviewWindowsTests {
    private let left = DisplayGeometry(
        id: 1, frame: CGRect(x: -1920, y: 0, width: 1920, height: 1080), isPrimary: false, name: "Left")
    private let right = DisplayGeometry(
        id: 2, frame: CGRect(x: 0, y: 0, width: 1920, height: 1080), isPrimary: true, name: "Right")

    private func window(_ id: CGWindowID, pid: pid_t, x: CGFloat, fullScreen: Bool = false) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: pid, cgWindowId: id, fallbackKey: "\(pid):\(id)"),
            ownerPid: pid, ownerName: "App", title: "Doc",
            bounds: CGRect(x: x, y: 100, width: 800, height: 600),
            isMinimized: false, isFullScreen: fullScreen, isOnScreen: true, zOrder: 0, source: .both)
    }

    @Test func aWindowOnThisDisplayNamesNoDisplay() {
        let preview = TaskbarPreviewWindows.of(window(10, pid: 5, x: 100), onDisplay: 2, displays: [left, right])

        #expect(preview?.displayName == nil)
        #expect(preview?.size == CGSize(width: 800, height: 600))
    }

    @Test func aWindowOnAnotherDisplayNamesIt() {
        let preview = TaskbarPreviewWindows.of(window(10, pid: 5, x: -1500), onDisplay: 2, displays: [left, right])

        #expect(preview?.displayName == "Left")
    }

    @Test func aFullScreenWindowSaysSo() {
        let preview = TaskbarPreviewWindows.of(
            window(10, pid: 5, x: 100, fullScreen: true), onDisplay: 2, displays: [left, right])

        #expect(preview?.isFullScreen == true)
    }

    @Test func anApplicationsWindowsElsewhereAreGatheredByItsBundle() {
        let windows = [window(10, pid: 5, x: -1500), window(11, pid: 5, x: -1200), window(12, pid: 6, x: -1000)]
        let bundles: [pid_t: String] = [5: "com.example.term", 6: "com.example.other"]

        let previews = TaskbarPreviewWindows.of(
            bundleIdentifier: "com.example.term", among: windows, bundleIdentifiers: bundles,
            onDisplay: 2, displays: [left, right])

        #expect(previews.map(\.id) == [10, 11])
        #expect(previews.map(\.displayName) == ["Left", "Left"])
    }

    @Test func aWindowWithNoCoreGraphicsIdIsSkipped() {
        let window = ManagedWindow(
            identity: WindowIdentity(ownerPid: 5, cgWindowId: nil, fallbackKey: "5:ax0"),
            ownerPid: 5, ownerName: "App", title: "Doc", bounds: nil,
            isMinimized: true, isFullScreen: false, isOnScreen: false, zOrder: nil, source: .accessibilityOnly)

        #expect(TaskbarPreviewWindows.of(window, onDisplay: 2, displays: [left, right]) == nil)
    }
}
