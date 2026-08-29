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

/** One running session, as the channel writes it. */
package struct SessionSignal: Codable, Sendable, Equatable {
    package let sessionId: String
    package let title: String
    package let standing: String?
    package let waitingFor: String?
    package let quietSince: Date?
    package let isTerminal: Bool
    package let pane: String?
    package let project: String?
    package let doing: String?
    package let outputTokens: Int?
    package let contextTokens: Int?
    package let contextLimit: Int?

    package func toEntity() -> ClaudeSession {
        ClaudeSession(
            sessionId: sessionId,
            title: title,
            standing: SessionStanding.of(standing),
            waitingFor: waitingFor,
            quietSince: quietSince,
            isTerminal: isTerminal,
            pane: pane,
            project: project,
            doing: doing,
            outputTokens: outputTokens,
            context: context
        )
    }

    private var context: SessionContext? {
        guard let contextTokens, let contextLimit else { return nil }

        return SessionContext(tokens: contextTokens, limit: contextLimit)
    }
}
