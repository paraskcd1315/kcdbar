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

package enum TaskbarOrdering {
    package static func applicationKey(_ bundleIdentifier: String) -> String {
        "app:\(bundleIdentifier)"
    }

    package static func orderingKey(bundleIdentifier: String?, entryId: String) -> String {
        guard let bundleIdentifier else { return entryId }

        return applicationKey(bundleIdentifier)
    }

    package static func ordered(
        entries: [TaskbarEntryModel],
        ranks: [String: Int]
    ) -> [TaskbarEntryModel] {
        entries.sorted { first, second in
            let firstRank = ranks[first.orderingKey, default: .max]
            let secondRank = ranks[second.orderingKey, default: .max]

            guard firstRank == secondRank else { return firstRank < secondRank }

            let firstSeen = ranks[first.id, default: .max]
            let secondSeen = ranks[second.id, default: .max]

            guard firstSeen == secondSeen else { return firstSeen < secondSeen }

            return first.id < second.id
        }
    }
}
