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

struct WindowGroupToggleDeciderTests {
    private func window(
        _ id: UInt32,
        pid: pid_t = 5,
        minimized: Bool = false,
        zOrder: Int = 0
    ) -> ManagedWindow {
        ManagedWindow(
            identity: WindowIdentity(ownerPid: pid, cgWindowId: id, fallbackKey: "\(pid):\(id)"),
            ownerPid: pid,
            ownerName: "app",
            title: "w\(id)",
            bounds: CGRect(x: 0, y: 0, width: 800, height: 600),
            isMinimized: minimized,
            isFullScreen: false,
            isOnScreen: !minimized,
            zOrder: minimized ? nil : zOrder,
            source: .both
        )
    }

    @Test func aGroupInFrontMinimizesEveryWindow() {
        let group = [window(1, zOrder: 0), window(2, zOrder: 1)]

        #expect(
            WindowGroupToggleDecider.action(for: group, frontmostPid: 5, among: group)
                == .minimizeAll
        )
    }

    @Test func aGroupEntirelyMinimizedRestoresEveryWindow() {
        let group = [window(1, minimized: true), window(2, minimized: true)]

        #expect(
            WindowGroupToggleDecider.action(for: group, frontmostPid: 9, among: group)
                == .restoreAll
        )
    }

    @Test func aGroupBehindAnotherApplicationIsRaised() {
        let group = [window(1, zOrder: 2), window(2, zOrder: 3)]
        let other = window(3, pid: 9, zOrder: 0)

        #expect(
            WindowGroupToggleDecider.action(for: group, frontmostPid: 9, among: group + [other])
                == .raise
        )
    }

    @Test func aGroupOnlyPartlyMinimizedIsRaisedRatherThanRestored() {
        let group = [window(1, minimized: true), window(2, zOrder: 2)]
        let other = window(3, pid: 9, zOrder: 0)

        #expect(
            WindowGroupToggleDecider.action(for: group, frontmostPid: 9, among: group + [other])
                == .raise
        )
    }

    @Test func anEmptyGroupIsRaisedRatherThanRestored() {
        #expect(
            WindowGroupToggleDecider.action(for: [], frontmostPid: 5, among: []) == .raise
        )
    }

    @Test func oneWindowOfTheGroupInFrontMinimizesThemAll() {
        let group = [window(1, zOrder: 0), window(2, zOrder: 4), window(3, minimized: true)]

        #expect(
            WindowGroupToggleDecider.action(for: group, frontmostPid: 5, among: group)
                == .minimizeAll
        )
    }
}
