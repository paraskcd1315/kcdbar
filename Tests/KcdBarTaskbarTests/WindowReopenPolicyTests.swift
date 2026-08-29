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

struct WindowReopenPolicyTests {
    @Test func aRaiseThatFailedReopens() {
        #expect(WindowReopenPolicy.reopens(after: .raise, performed: false))
    }

    @Test func aRestoreThatFailedReopens() {
        #expect(WindowReopenPolicy.reopens(after: .restore, performed: false))
    }

    @Test func aMinimizeThatFailedDoesNotReopen() {
        #expect(WindowReopenPolicy.reopens(after: .minimize, performed: false) == false)
    }

    @Test func aRaiseThatSucceededDoesNotReopen() {
        #expect(WindowReopenPolicy.reopens(after: .raise, performed: true) == false)
    }
}
