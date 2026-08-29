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

/** The bar's live view of what is running, and of a channel it could not read. */
@MainActor
@Observable
package final class TimerMonitor {
    package private(set) var reading: TimerReading = .unknown
    package private(set) var problem: ChannelProblem?

    private let source: any TimerSignalPort
    private let tickets: any TicketOpenerPort
    private let availability: any SignalAvailabilityPort

    package var isAvailable: Bool { availability.isPresent }

    package init(
        source: any TimerSignalPort,
        tickets: any TicketOpenerPort,
        availability: any SignalAvailabilityPort = KcdSignalAvailability()
    ) {
        self.source = source
        self.tickets = tickets
        self.availability = availability
    }

    package func open(_ timer: RunningTimer) {
        guard let contextPath = timer.contextPath, let key = timer.jiraKey else { return }

        Task { [tickets] in
            _ = await tickets.open(contextPath: contextPath, key: key)
        }
    }

    package func start() {
        source.listen({ [weak self] reading in
            self?.apply(reading)
        }, onProblem: { [weak self] problem in
            self?.apply(problem)
        })
    }

    package func stop() {
        source.stop()
    }

    package func apply(_ reading: TimerReading) {
        self.reading = reading
        self.problem = nil
    }

    package func apply(_ problem: ChannelProblem) {
        self.problem = problem
        self.reading = .unknown
    }
}
