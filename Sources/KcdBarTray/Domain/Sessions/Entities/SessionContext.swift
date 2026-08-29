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

/** How much of a session's context window is in use. */
package struct SessionContext: Equatable, Sendable {
    package static let tightShare = 0.75
    package static let criticalShare = 0.90

    package let tokens: Int
    package let limit: Int

    package init(tokens: Int, limit: Int) {
        self.tokens = tokens
        self.limit = limit
    }

    package var share: Double { limit > 0 ? Double(tokens) / Double(limit) : 0 }

    package var isTight: Bool { share >= Self.tightShare }

    package var isCritical: Bool { share >= Self.criticalShare }
}
