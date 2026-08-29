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

/** One tracked entry of a day, whose absent `endedAt` is what marks it still running. */
package struct DayEntry: Equatable, Sendable, Identifiable {
    package let id: Int
    package let detail: String
    package let projectId: Int?
    package let jiraKey: String?
    package let contextPath: String?
    package let startedAt: Date
    package let endedAt: Date?
    package let isBillable: Bool

    package init(
        id: Int,
        detail: String,
        projectId: Int?,
        jiraKey: String?,
        contextPath: String?,
        startedAt: Date,
        endedAt: Date?,
        isBillable: Bool
    ) {
        self.id = id
        self.detail = detail
        self.projectId = projectId
        self.jiraKey = jiraKey
        self.contextPath = contextPath
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.isBillable = isBillable
    }

    package var isRunning: Bool { endedAt == nil }

    package var opensATicket: Bool { contextPath != nil && jiraKey != nil }

    package func endedAt(by moment: Date) -> Date { endedAt ?? moment }
}
