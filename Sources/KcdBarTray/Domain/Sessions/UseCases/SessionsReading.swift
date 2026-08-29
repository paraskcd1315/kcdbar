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

/** What the bar says about every session at once, which is the value the rim is drawn from. */
package enum SessionsReading: Equatable, Sendable {
    case unknown
    case quiet
    case working
    case waiting

    package static func of(_ sessions: [ClaudeSession]?) -> SessionsReading {
        guard let sessions else { return .unknown }

        if sessions.contains(where: \.isBlocked) { return .waiting }

        if sessions.contains(where: \.isWorking) { return .working }

        return .quiet
    }

    package var isWorking: Bool { self == .working || self == .waiting }

    package var wantsAttention: Bool { self == .waiting }
}
