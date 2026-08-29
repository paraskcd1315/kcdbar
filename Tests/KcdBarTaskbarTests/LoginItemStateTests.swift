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

private final class FakeLoginItem: LoginItemPort, @unchecked Sendable {
    var enabled: Bool
    private(set) var writes: [Bool] = []

    init(enabled: Bool) {
        self.enabled = enabled
    }

    var isEnabled: Bool { enabled }

    func setEnabled(_ enabled: Bool) {
        writes.append(enabled)
        self.enabled = enabled
    }
}

@MainActor
struct LoginItemStateTests {
    @Test func readsTheServicesAnswerAtBirth() {
        let port = FakeLoginItem(enabled: true)

        #expect(LoginItemState(port: port).isEnabled)
    }

    @Test func togglingWritesTheOppositeAndReadsBack() {
        let port = FakeLoginItem(enabled: false)
        let state = LoginItemState(port: port)

        state.toggle()

        #expect(port.writes == [true])
        #expect(state.isEnabled)
    }

    @Test func aRefusedWriteLeavesTheStateOnWhatTheServiceReports() {
        let port = FakeLoginItem(enabled: false)
        let state = LoginItemState(port: port)
        port.enabled = false

        state.toggle()
        port.enabled = false
        state.refresh()

        #expect(state.isEnabled == false)
    }
}
