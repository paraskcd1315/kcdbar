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

/** One day of tracked time, as the channel writes it. */
package struct DaySignal: Codable, Sendable, Equatable {
    package let day: Date
    package let entries: [DayEntrySignal]
    package let projects: [DayProjectSignal]

    package func toEntity() -> TrackerDay {
        TrackerDay(
            day: day,
            entries: entries.map { $0.toEntity() },
            projects: projects.map { $0.toEntity() }
        )
    }
}
