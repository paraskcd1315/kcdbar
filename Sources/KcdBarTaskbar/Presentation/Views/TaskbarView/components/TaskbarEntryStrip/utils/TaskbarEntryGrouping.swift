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

package enum TaskbarEntryGrouping {
    package static func groups(from entries: [TaskbarEntryModel]) -> [TaskbarEntryGroup] {
        var groups: [TaskbarEntryGroup] = []

        for entry in entries {
            let key = entry.orderingKey
            if let last = groups.last, last.id == key {
                groups[groups.count - 1] = TaskbarEntryGroup(id: key, entries: last.entries + [entry])
            } else {
                groups.append(TaskbarEntryGroup(id: key, entries: [entry]))
            }
        }

        return groups
    }
}
