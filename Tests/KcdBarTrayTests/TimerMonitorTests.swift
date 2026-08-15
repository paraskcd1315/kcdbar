import Foundation
import Testing

@testable import KcdBarTray

@MainActor
private final class FakeTimerSignalSource: TimerSignalPort {
    private var onChange: (@MainActor @Sendable (TimerReading) -> Void)?

    private(set) var isStopped = false

    func listen(_ onChange: @escaping @MainActor @Sendable (TimerReading) -> Void) {
        self.onChange = onChange
    }

    func stop() {
        isStopped = true
    }

    func send(_ reading: TimerReading) {
        onChange?(reading)
    }
}

@MainActor
struct TimerMonitorTests {
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
        let monitor = TimerMonitor(source: FakeTimerSignalSource())

        #expect(monitor.reading == .unknown)
    }

    @Test func theChannelsFirstValueReachesTheMonitor() {
        let source = FakeTimerSignalSource()
        let monitor = TimerMonitor(source: source)
        monitor.start()

        source.send(.running([timer()]))

        #expect(monitor.reading == .running([timer()]))
    }

    @Test func aTimerStoppingLeavesIdleRatherThanUnknown() {
        let source = FakeTimerSignalSource()
        let monitor = TimerMonitor(source: source)
        monitor.start()

        source.send(.running([timer()]))
        source.send(.idle)

        #expect(monitor.reading == .idle)
    }

    @Test func stoppingTheMonitorStopsTheChannel() {
        let source = FakeTimerSignalSource()
        let monitor = TimerMonitor(source: source)
        monitor.start()
        monitor.stop()

        #expect(source.isStopped)
    }
}
