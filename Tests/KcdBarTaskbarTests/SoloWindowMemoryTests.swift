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

struct SoloWindowMemoryTests {
    private func identity(_ id: CGWindowID) -> WindowIdentity {
        WindowIdentity(ownerPid: pid_t(id), cgWindowId: id, fallbackKey: "\(id)")
    }

    private func window(_ id: CGWindowID) -> ManagedWindow {
        ManagedWindow(
            identity: identity(id),
            ownerPid: pid_t(id),
            ownerName: "app",
            title: "w\(id)",
            bounds: CGRect(x: 0, y: 0, width: 100, height: 100),
            isMinimized: false,
            isFullScreen: false,
            isOnScreen: true,
            zOrder: Int(id),
            source: .both
        )
    }

    @Test func theLastDisplacedWindowComesBackFirst() {
        var memory = SoloWindowMemory()
        memory.remember([window(1)], onDisplay: 1)
        memory.remember([window(2)], onDisplay: 1)

        #expect(memory.takeMostRecent(onDisplay: 1) == identity(2))
        #expect(memory.takeMostRecent(onDisplay: 1) == identity(1))
        #expect(memory.takeMostRecent(onDisplay: 1) == nil)
    }

    @Test func eachDisplayKeepsItsOwnStack() {
        var memory = SoloWindowMemory()
        memory.remember([window(1)], onDisplay: 1)
        memory.remember([window(2)], onDisplay: 2)

        #expect(memory.takeMostRecent(onDisplay: 2) == identity(2))
        #expect(memory.takeMostRecent(onDisplay: 1) == identity(1))
    }

    @Test func rememberingTwiceDoesNotStackTheSameWindow() {
        var memory = SoloWindowMemory()
        memory.remember([window(1)], onDisplay: 1)
        memory.remember([window(1)], onDisplay: 1)

        #expect(memory.takeMostRecent(onDisplay: 1) == identity(1))
        #expect(memory.takeMostRecent(onDisplay: 1) == nil)
    }

    @Test func aClosedWindowIsForgotten() {
        var memory = SoloWindowMemory()
        memory.remember([window(1), window(2)], onDisplay: 1)
        memory.drop(identitiesNotIn: [identity(2)])

        #expect(memory.takeMostRecent(onDisplay: 1) == identity(2))
        #expect(memory.takeMostRecent(onDisplay: 1) == nil)
    }
}
