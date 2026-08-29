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

/** One day of tracked time, dated so a snapshot nobody replaced overnight cannot read as today. */
package struct TrackerDay: Equatable, Sendable {
    package let day: Date
    package let entries: [DayEntry]
    package let projects: [DayProject]

    package init(day: Date, entries: [DayEntry], projects: [DayProject]) {
        self.day = day
        self.entries = entries
        self.projects = projects
    }

    package func project(of entry: DayEntry) -> DayProject? {
        guard let id = entry.projectId else { return nil }

        return projects.first { $0.id == id }
    }

    package func covers(_ moment: Date, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(day, inSameDayAs: moment)
    }
}
