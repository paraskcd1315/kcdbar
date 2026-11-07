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

struct WindowPeekPolicyTests {
    private let displays = [
        DisplayGeometry(id: 1, frame: CGRect(x: 0, y: 0, width: 1920, height: 1080), isPrimary: true),
        DisplayGeometry(id: 2, frame: CGRect(x: 1920, y: 0, width: 1920, height: 1080), isPrimary: false)
    ]

    private func window(
        id: CGWindowID,
        bounds: CGRect = CGRect(x: 100, y: 100, width: 800, height: 600),
        isFullScreen: Bool = false,
        isMinimized: Bool = false,
        zOrder: Int? = 0,
        source: WindowRecordSource = .both
    ) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: 1, cgWindowId: id, fallbackKey: "1:\(id)"),
            ownerPid: 1,
            ownerName: "App",
            title: "Window",
            bounds: bounds,
            isMinimized: isMinimized,
            isFullScreen: isFullScreen,
            isOnScreen: true,
            zOrder: zOrder,
            source: source
        )
    }

    @Test func theDesktopPeekCoversEveryDisplayShowingItsDesktop() {
        let ids = WindowPeekPolicy.displayIds(for: .desktop, windows: [window(id: 1)], displays: displays)

        #expect(ids == [1, 2])
    }

    @Test func aDisplayShowingAFullscreenWindowIsNeverPeeked() {
        let fullscreen = window(id: 2, bounds: displays[1].frame, isFullScreen: true)

        let ids = WindowPeekPolicy.displayIds(for: .desktop, windows: [fullscreen], displays: displays)

        #expect(ids == [1])
    }

    @Test func aWindowOnTheDesktopPeeksEveryDesktopDisplay() {
        let ids = WindowPeekPolicy.displayIds(for: .window(1), windows: [window(id: 1)], displays: displays)

        #expect(ids == [1, 2])
    }

    @Test func aFullscreenWindowIsNeverPeeked() {
        let fullscreen = window(id: 3, bounds: displays[0].frame, isFullScreen: true, zOrder: Int.max)

        let ids = WindowPeekPolicy.displayIds(for: .window(3), windows: [fullscreen], displays: displays)

        #expect(ids.isEmpty)
    }

    @Test func aMinimizedWindowIsNeverPeeked() {
        let ids = WindowPeekPolicy.displayIds(
            for: .window(4),
            windows: [window(id: 4, isMinimized: true)],
            displays: displays
        )

        #expect(ids.isEmpty)
    }

    @Test func aWindowOnAnotherSpaceIsNeverPeeked() {
        let ids = WindowPeekPolicy.displayIds(
            for: .window(5),
            windows: [window(id: 5, source: .inactiveSpace)],
            displays: displays
        )

        #expect(ids.isEmpty)
    }

    @Test func aWindowOnADisplayShowingAFullscreenWindowIsNeverPeeked() {
        let fullscreen = window(id: 6, bounds: displays[0].frame, isFullScreen: true, zOrder: 0)
        let behind = window(id: 7, zOrder: 1)

        let ids = WindowPeekPolicy.displayIds(for: .window(7), windows: [fullscreen, behind], displays: displays)

        #expect(ids.isEmpty)
    }

    @Test func anUnknownWindowIsNeverPeeked() {
        let ids = WindowPeekPolicy.displayIds(for: .window(99), windows: [window(id: 1)], displays: displays)

        #expect(ids.isEmpty)
    }
}
