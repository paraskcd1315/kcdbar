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

/** Everything the Dock service must do for one change, decided in one place. */
package struct DockDecision: Equatable, Sendable {
    package let capture: DockSettingsSnapshot?
    package let write: [DockDefault]
    package let restart: Bool
    package let forget: Bool
    package let verdict: DockVerdict

    package init(
        capture: DockSettingsSnapshot?,
        write: [DockDefault],
        restart: Bool,
        forget: Bool,
        verdict: DockVerdict
    ) {
        self.capture = capture
        self.write = write
        self.restart = restart
        self.forget = forget
        self.verdict = verdict
    }

    package static func nothing(_ verdict: DockVerdict) -> DockDecision {
        DockDecision(capture: nil, write: [], restart: false, forget: false, verdict: verdict)
    }
}
