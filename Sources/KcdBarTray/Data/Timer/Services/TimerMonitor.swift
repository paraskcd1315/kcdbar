import Observation

/** The bar's live view of the timer running for this project. */
@MainActor
@Observable
package final class TimerMonitor {
    package private(set) var reading: TimerReading = .unknown

    private let source: any TimerSignalPort

    package init(source: any TimerSignalPort) {
        self.source = source
    }

    package func start() {
        source.listen { [weak self] reading in
            self?.apply(reading)
        }
    }

    package func stop() {
        source.stop()
    }

    package func apply(_ reading: TimerReading) {
        self.reading = reading
    }
}
