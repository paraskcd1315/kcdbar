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

import Foundation

/** The order the bar's entries are shown in, keyed by ordering key. */
@MainActor
@Observable
package final class EntryOrderMemory {
    package init() {}

    package private(set) var keys: [String] = []

    package var ranks: [String: Int] {
        Dictionary(uniqueKeysWithValues: keys.enumerated().map { ($0.element, $0.offset) })
    }

    package func note(keys incoming: [String]) {
        let live = Set(incoming)
        keys.removeAll { !live.contains($0) }

        let held = Set(keys)
        keys.append(contentsOf: incoming.filter { !held.contains($0) })
    }

    package func seed(keys leading: [String]) {
        let led = Set(leading)
        keys = leading + keys.filter { !led.contains($0) }
    }

    package func move(key: String, onto target: String) {
        keys = OrderedKeys.moving(key, onto: target, in: keys)
    }
}
