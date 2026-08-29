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
import Testing

@testable import KcdBarTray

@MainActor
private final class FakeTimerSignalSource: TimerSignalPort {
    private var onChange: (@MainActor @Sendable (TimerReading) -> Void)?
    private var onProblem: (@MainActor @Sendable (ChannelProblem) -> Void)?

    private(set) var isStopped = false

    func listen(
        _ onChange: @escaping @MainActor @Sendable (TimerReading) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {
        self.onChange = onChange
        self.onProblem = onProblem
    }

    func stop() {
        isStopped = true
    }

    func send(_ reading: TimerReading) {
        onChange?(reading)
    }

    func send(_ problem: ChannelProblem) {
        onProblem?(problem)
    }
}

private struct FakeTicketOpener: TicketOpenerPort {
    var isAvailable: Bool { true }

    func open(contextPath: String, key: String) async -> Bool { true }
}

@MainActor
struct TimerMonitorTests {
    private func monitor(_ source: FakeTimerSignalSource) -> TimerMonitor {
        TimerMonitor(source: source, tickets: FakeTicketOpener())
    }

    private func timer() -> RunningTimer {
        RunningTimer(
            projectId: 13,
            jiraKey: "KCDBAR-37",
            detail: "a timer",
            startedAt: Date(timeIntervalSince1970: 0),
            isBillable: true,
            source: "kimai"
        )
    }

    @Test func aMonitorThatHasHeardNothingReadsAsUnknown() {
        let monitor = monitor(FakeTimerSignalSource())

        #expect(monitor.reading == .unknown)
    }

    @Test func theChannelsFirstValueReachesTheMonitor() {
        let source = FakeTimerSignalSource()
        let monitor = monitor(source)
        monitor.start()

        source.send(.running([timer()]))

        #expect(monitor.reading == .running([timer()]))
    }

    @Test func aTimerStoppingLeavesIdleRatherThanUnknown() {
        let source = FakeTimerSignalSource()
        let monitor = monitor(source)
        monitor.start()

        source.send(.running([timer()]))
        source.send(.idle)

        #expect(monitor.reading == .idle)
    }

    @Test func aVersionThisReaderDoesNotKnowIsNotAnEmptyChannel() {
        let source = FakeTimerSignalSource()
        let monitor = monitor(source)
        monitor.start()

        source.send(.running([timer()]))
        source.send(ChannelProblem.unknownVersion(2))

        #expect(monitor.problem == .unknownVersion(2))
        #expect(monitor.reading == .unknown)
    }

    @Test func aReadableSnapshotClearsTheProblemBeforeIt() {
        let source = FakeTimerSignalSource()
        let monitor = monitor(source)
        monitor.start()

        source.send(ChannelProblem.malformed("bad"))
        source.send(.idle)

        #expect(monitor.problem == nil)
        #expect(monitor.reading == .idle)
    }

    @Test func stoppingTheMonitorStopsTheChannel() {
        let source = FakeTimerSignalSource()
        let monitor = monitor(source)
        monitor.start()
        monitor.stop()

        #expect(source.isStopped)
    }
}
