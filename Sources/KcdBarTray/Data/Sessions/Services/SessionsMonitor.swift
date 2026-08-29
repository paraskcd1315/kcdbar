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

import Observation

/** The bar's live view of every Claude session on this machine. */
@MainActor
@Observable
package final class SessionsMonitor {
    package private(set) var sessions: [ClaudeSession]?
    package private(set) var problem: ChannelProblem?

    private let source: any SessionsSignalPort
    private let panes: any PaneFocusPort

    package init(source: any SessionsSignalPort, panes: any PaneFocusPort) {
        self.source = source
        self.panes = panes
    }

    package var reading: SessionsReading { SessionsReading.of(sessions) }

    package var isAvailable: Bool { sessions != nil }

    package func focus(_ session: ClaudeSession) {
        guard let pane = session.pane, !pane.isEmpty else { return }

        Task { [panes] in
            _ = await panes.focus(pane: pane)
        }
    }

    package func start() {
        source.listen({ [weak self] sessions in
            self?.apply(sessions)
        }, onProblem: { [weak self] problem in
            self?.apply(problem)
        })
    }

    package func stop() {
        source.stop()
    }

    package func apply(_ sessions: [ClaudeSession]) {
        self.sessions = sessions
        self.problem = nil
    }

    package func apply(_ problem: ChannelProblem) {
        self.problem = problem
        self.sessions = nil
    }
}
