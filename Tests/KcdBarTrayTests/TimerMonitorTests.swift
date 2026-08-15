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

    @Test func aVersionThisReaderDoesNotKnowIsNotAnEmptyChannel() {
        let source = FakeTimerSignalSource()
        let monitor = TimerMonitor(source: source)
        monitor.start()

        source.send(.running([timer()]))
        source.send(ChannelProblem.unknownVersion(2))

        #expect(monitor.problem == .unknownVersion(2))
        #expect(monitor.reading == .unknown)
    }

    @Test func aReadableSnapshotClearsTheProblemBeforeIt() {
        let source = FakeTimerSignalSource()
        let monitor = TimerMonitor(source: source)
        monitor.start()

        source.send(ChannelProblem.malformed("bad"))
        source.send(.idle)

        #expect(monitor.problem == nil)
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
