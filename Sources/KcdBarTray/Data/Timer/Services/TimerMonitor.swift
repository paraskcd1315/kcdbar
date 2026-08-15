import Observation

/** The bar's live view of what is running, and of a channel it could not read. */
@MainActor
@Observable
package final class TimerMonitor {
    package private(set) var reading: TimerReading = .unknown
    package private(set) var problem: ChannelProblem?

    private let source: any TimerSignalPort

    package init(source: any TimerSignalPort) {
        self.source = source
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
