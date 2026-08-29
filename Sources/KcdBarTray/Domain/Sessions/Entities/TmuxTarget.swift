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

/** A tmux pane address, split into the two targets selecting it takes. */
package struct TmuxTarget: Equatable, Sendable {
    package let window: String
    package let pane: String

    package init(window: String, pane: String) {
        self.window = window
        self.pane = pane
    }

    package static func of(_ address: String) -> TmuxTarget? {
        let trimmed = address.trimmingCharacters(in: .whitespaces)

        guard let split = trimmed.lastIndex(of: ".") else { return nil }

        let window = String(trimmed[trimmed.startIndex..<split])
        let pane = String(trimmed[trimmed.index(after: split)...])

        guard !window.isEmpty, !pane.isEmpty else { return nil }

        return TmuxTarget(window: window, pane: pane)
    }
}
