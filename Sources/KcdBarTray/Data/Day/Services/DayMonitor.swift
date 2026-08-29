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

/** The bar's live view of the day being tracked. */
@MainActor
@Observable
package final class DayMonitor {
    package private(set) var day: TrackerDay?
    package private(set) var problem: ChannelProblem?

    private let source: any DaySignalPort
    private let tickets: any TicketOpenerPort

    package init(source: any DaySignalPort, tickets: any TicketOpenerPort) {
        self.source = source
        self.tickets = tickets
    }

    package func open(_ entry: DayEntry) {
        guard let contextPath = entry.contextPath, let key = entry.jiraKey else { return }

        Task { [tickets] in
            _ = await tickets.open(contextPath: contextPath, key: key)
        }
    }

    package func start() {
        source.listen({ [weak self] day in
            self?.apply(day)
        }, onProblem: { [weak self] problem in
            self?.apply(problem)
        })
    }

    package func stop() {
        source.stop()
    }

    package func apply(_ day: TrackerDay) {
        self.day = day
        self.problem = nil
    }

    package func apply(_ problem: ChannelProblem) {
        self.problem = problem
        self.day = nil
    }
}
