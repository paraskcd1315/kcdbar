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

/** Everything the channel reports as running, this project's timers first. */
package enum TimerSelection {
    package static func reading(from timers: [RunningTimer]?, projectId: Int) -> TimerReading {
        guard let timers else { return .unknown }
        guard !timers.isEmpty else { return .idle }

        return .running(ordered(timers, projectId: projectId))
    }

    package static func ordered(_ timers: [RunningTimer], projectId: Int) -> [RunningTimer] {
        timers.sorted { left, right in
            let leftIsOurs = left.projectId == projectId
            let rightIsOurs = right.projectId == projectId
            guard leftIsOurs == rightIsOurs else { return leftIsOurs }

            return left.startedAt < right.startedAt
        }
    }
}
