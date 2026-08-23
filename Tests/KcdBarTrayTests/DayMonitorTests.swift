import Foundation
import Testing

@testable import KcdBarTray

@MainActor
private final class FakeDaySignalSource: DaySignalPort {
    private var onChange: (@MainActor @Sendable (TrackerDay) -> Void)?
    private var onProblem: (@MainActor @Sendable (ChannelProblem) -> Void)?

    private(set) var isStopped = false

    func listen(
        _ onChange: @escaping @MainActor @Sendable (TrackerDay) -> Void,
        onProblem: @escaping @MainActor @Sendable (ChannelProblem) -> Void
    ) {
        self.onChange = onChange
        self.onProblem = onProblem
    }

    func stop() {
        isStopped = true
    }

    func send(_ day: TrackerDay) {
        onChange?(day)
    }

    func send(_ problem: ChannelProblem) {
        onProblem?(problem)
    }
}

@MainActor
struct DayMonitorTests {
    private let epoch = Date(timeIntervalSince1970: 1_786_017_600)

    private func entry(_ id: Int) -> DayEntry {
        DayEntry(
            id: id,
            detail: "KCDBAR-97 the day in the popover",
            projectId: 13,
            jiraKey: "KCDBAR-97",
            contextPath: "PersonalProjects/KCDBar",
            startedAt: epoch,
            endedAt: nil,
            isBillable: false)
    }

    private func day(_ entries: [DayEntry]) -> TrackerDay {
        TrackerDay(day: epoch, entries: entries, projects: [])
    }

    @Test func aMonitorThatHasHeardNothingHoldsNoDay() {
        let monitor = DayMonitor(source: FakeDaySignalSource())

        #expect(monitor.day == nil)
        #expect(monitor.problem == nil)
    }

    @Test func theChannelsFirstValueReachesTheMonitor() {
        let source = FakeDaySignalSource()
        let monitor = DayMonitor(source: source)
        monitor.start()

        source.send(day([entry(1)]))

        #expect(monitor.day == day([entry(1)]))
    }

    @Test func aDayEmptyingIsNotADayNobodyPublished() {
        let source = FakeDaySignalSource()
        let monitor = DayMonitor(source: source)
        monitor.start()

        source.send(day([entry(1)]))
        source.send(day([]))

        #expect(monitor.day?.entries.isEmpty == true)
        #expect(monitor.day != nil)
    }

    @Test func aChannelThisReaderCannotReadTakesTheDayDownWithIt() {
        let source = FakeDaySignalSource()
        let monitor = DayMonitor(source: source)
        monitor.start()

        source.send(day([entry(1)]))
        source.send(ChannelProblem.unknownVersion(2))

        #expect(monitor.problem == .unknownVersion(2))
        #expect(monitor.day == nil)
    }

    @Test func aReadableSnapshotClearsTheProblemBeforeIt() {
        let source = FakeDaySignalSource()
        let monitor = DayMonitor(source: source)
        monitor.start()

        source.send(ChannelProblem.malformed("bad"))
        source.send(day([entry(1)]))

        #expect(monitor.problem == nil)
        #expect(monitor.day != nil)
    }

    @Test func stoppingTheMonitorStopsTheChannel() {
        let source = FakeDaySignalSource()
        let monitor = DayMonitor(source: source)
        monitor.start()
        monitor.stop()

        #expect(source.isStopped)
    }
}
