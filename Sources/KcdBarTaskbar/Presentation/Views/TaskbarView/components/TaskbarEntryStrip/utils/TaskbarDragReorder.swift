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

package enum TaskbarDragReorder {
    package static func preview(
        entries: [TaskbarEntryModel],
        dragging: String?,
        over: String?
    ) -> [TaskbarEntryModel] {
        guard let dragging, let over, dragging != over else { return entries }

        let keys = slots(in: entries)
        let moved = OrderedKeys.moving(dragging, onto: over, in: keys)
        guard moved != keys else { return entries }

        let grouped = Dictionary(grouping: entries, by: \.orderingKey)

        return moved.flatMap { grouped[$0] ?? [] }
    }

    private static func slots(in entries: [TaskbarEntryModel]) -> [String] {
        var keys: [String] = []
        for entry in entries where !keys.contains(entry.orderingKey) {
            keys.append(entry.orderingKey)
        }

        return keys
    }
}
