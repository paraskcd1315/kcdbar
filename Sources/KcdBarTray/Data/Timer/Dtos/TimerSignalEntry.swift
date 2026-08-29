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

/** One timer as the channel writes it. */
package struct TimerSignalEntry: Codable, Sendable, Equatable {
    package let isRunning: Bool
    package let source: String
    package let jiraKey: String?
    package let detail: String
    package let startedAt: Date
    package let seconds: Int
    package let isBillable: Bool
    package let projectId: Int?
    package let contextPath: String?

    package func toEntity() -> RunningTimer {
        RunningTimer(
            projectId: projectId,
            contextPath: contextPath,
            jiraKey: jiraKey,
            detail: detail,
            startedAt: startedAt,
            isBillable: isBillable,
            source: source
        )
    }
}
