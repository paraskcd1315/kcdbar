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

@testable import KcdBarDesignSystem

struct ArraySafeSubscriptTests {
    private let entries = ["clock", "battery", "wifi"]

    @Test func anIndexInsideTheArrayAnswersItsElement() {
        #expect(entries[safe: 0] == "clock")
        #expect(entries[safe: 2] == "wifi")
    }

    @Test func anIndexPastTheEndAnswersNilRatherThanTrapping() {
        #expect(entries[safe: 3] == nil)
        #expect(entries[safe: 99] == nil)
    }

    @Test func aNegativeIndexAnswersNilRatherThanTrapping() {
        #expect(entries[safe: -1] == nil)
    }

    @Test func anEmptyArrayAnswersNilForEveryIndex() {
        let empty: [String] = []

        #expect(empty[safe: 0] == nil)
        #expect(empty[safe: -1] == nil)
    }
}
