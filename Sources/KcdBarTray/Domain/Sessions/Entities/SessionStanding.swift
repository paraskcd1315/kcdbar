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

/** What a session says it is doing, in the words the machine's own record uses. */
package enum SessionStanding: String, Sendable, Equatable, CaseIterable {
    case busy
    case shell
    case idle
    case waiting

    package static func of(_ named: String?) -> SessionStanding? {
        guard let named else { return nil }

        return SessionStanding(rawValue: named.trimmingCharacters(in: .whitespaces).lowercased())
    }

    package var isWorking: Bool { self == .busy || self == .shell }

    package var isBlocked: Bool { self == .waiting }
}
