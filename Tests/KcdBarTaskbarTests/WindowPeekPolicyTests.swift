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
    private let left = CGRect(x: 100, y: 100, width: 800, height: 600)
    private let right = CGRect(x: 2100, y: 100, width: 800, height: 600)

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

    private func scenes(_ target: WindowPeekTarget, _ windows: [ManagedWindow]) -> [WindowPeekScene] {
        WindowPeekPolicy.scenes(for: target, windows: windows, displays: displays)
    }

    @Test func theDesktopPeekCoversEveryDisplayShowingItsDesktop() {
        #expect(scenes(.desktop, [window(id: 1)]).map(\.displayId) == [1, 2])
    }

    @Test func aDisplayShowingAFullscreenWindowIsNeverPeeked() {
        let fullscreen = window(id: 2, bounds: displays[1].frame, isFullScreen: true)

        #expect(scenes(.desktop, [fullscreen]).map(\.displayId) == [1])
    }

    @Test func aWindowOnTheDesktopPeeksEveryDesktopDisplayAndCutsItsHoleOnItsOwn() {
        let result = scenes(.window(1), [window(id: 1, bounds: left)])

        #expect(result.map(\.displayId) == [1, 2])
        #expect(result.map(\.peeked) == [left, nil])
    }

    @Test func everyOtherWindowBecomesAnOutlineOnItsDisplayBackToFront() {
        let front = window(id: 1, bounds: left, zOrder: 0)
        let back = window(id: 2, bounds: left.offsetBy(dx: 50, dy: 50), zOrder: 3)
        let elsewhere = window(id: 3, bounds: right, zOrder: 1)

        let result = scenes(.desktop, [front, back, elsewhere])

        #expect(result[0].outlines == [back.bounds, front.bounds])
        #expect(result[1].outlines == [right])
    }

    @Test func thePeekedWindowIsNeverAnOutline() {
        let peeked = window(id: 1, bounds: left, zOrder: 0)
        let other = window(id: 2, bounds: left.offsetBy(dx: 50, dy: 50), zOrder: 1)

        let result = scenes(.window(1), [peeked, other])

        #expect(result[0].outlines == [other.bounds])
    }

    @Test func aMinimizedWindowLeavesNoOutline() {
        let minimized = window(id: 2, isMinimized: true)

        #expect(scenes(.desktop, [minimized])[0].outlines.isEmpty)
    }

    @Test func aFullscreenWindowIsNeverPeeked() {
        let fullscreen = window(id: 3, bounds: displays[0].frame, isFullScreen: true, zOrder: Int.max)

        #expect(scenes(.window(3), [fullscreen]).isEmpty)
    }

    @Test func aMinimizedWindowIsNeverPeeked() {
        #expect(scenes(.window(4), [window(id: 4, isMinimized: true)]).isEmpty)
    }

    @Test func aWindowOnAnotherSpaceIsNeverPeeked() {
        #expect(scenes(.window(5), [window(id: 5, source: .inactiveSpace)]).isEmpty)
    }

    @Test func aWindowOnADisplayShowingAFullscreenWindowIsNeverPeeked() {
        let fullscreen = window(id: 6, bounds: displays[0].frame, isFullScreen: true, zOrder: 0)
        let behind = window(id: 7, zOrder: 1)

        #expect(scenes(.window(7), [fullscreen, behind]).isEmpty)
    }

    @Test func anUnknownWindowIsNeverPeeked() {
        #expect(scenes(.window(99), [window(id: 1)]).isEmpty)
    }
}
