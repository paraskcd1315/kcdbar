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

/** The single rule for where a dragged key lands: it takes the target's slot. */
package enum OrderedKeys {
    package static func moving(_ key: String, onto target: String, in keys: [String]) -> [String] {
        guard key != target, keys.contains(key), let slot = keys.firstIndex(of: target) else {
            return keys
        }

        var remaining = keys.filter { $0 != key }
        remaining.insert(key, at: min(slot, remaining.count))

        return remaining
    }

    package static func deduped(_ keys: [String]) -> [String] {
        var seen: Set<String> = []

        return keys.filter { seen.insert($0).inserted }
    }
}
