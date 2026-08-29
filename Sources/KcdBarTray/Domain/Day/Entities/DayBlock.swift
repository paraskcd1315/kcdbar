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

/** One entry placed on the day's grid, in fractions of that day, sharing its width with what overlaps it. */
package struct DayBlock: Equatable, Sendable, Identifiable {
    package let entry: DayEntry
    package let top: Double
    package let height: Double
    package let column: Int
    package let columns: Int

    package var id: Int { entry.id }

    package init(entry: DayEntry, top: Double, height: Double, column: Int, columns: Int) {
        self.entry = entry
        self.top = top
        self.height = height
        self.column = column
        self.columns = columns
    }
}
