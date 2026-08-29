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

/** One Claude session running on this machine, as the bar draws a row for it. */
package struct ClaudeSession: Equatable, Sendable, Identifiable {
    package let sessionId: String
    package let title: String
    package let standing: SessionStanding?
    package let waitingFor: String?
    package let quietSince: Date?
    package let isTerminal: Bool
    package let pane: String?
    package let project: String?
    package let doing: String?
    package let outputTokens: Int?
    package let context: SessionContext?

    package init(
        sessionId: String,
        title: String,
        standing: SessionStanding?,
        waitingFor: String?,
        quietSince: Date?,
        isTerminal: Bool,
        pane: String?,
        project: String?,
        doing: String?,
        outputTokens: Int?,
        context: SessionContext?
    ) {
        self.sessionId = sessionId
        self.title = title
        self.standing = standing
        self.waitingFor = waitingFor
        self.quietSince = quietSince
        self.isTerminal = isTerminal
        self.pane = pane
        self.project = project
        self.doing = doing
        self.outputTokens = outputTokens
        self.context = context
    }

    package var id: String { sessionId }

    package var isWorking: Bool { standing?.isWorking ?? false }

    package var isBlocked: Bool { standing?.isBlocked ?? false }

    package var hasPane: Bool { !(pane ?? "").isEmpty }

    package func quietFor(at moment: Date) -> TimeInterval? {
        guard let quietSince else { return nil }

        return max(0, moment.timeIntervalSince(quietSince))
    }
}
