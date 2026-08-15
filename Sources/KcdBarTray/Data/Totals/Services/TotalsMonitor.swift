import Observation

/** The bar's live view of today and this week. */
@MainActor
@Observable
package final class TotalsMonitor {
    package private(set) var totals: TrackerTotals?
    package private(set) var problem: ChannelProblem?

    private let source: any TotalsSignalPort

    package init(source: any TotalsSignalPort) {
        self.source = source
    }

    package func start() {
        source.listen({ [weak self] totals in
            self?.apply(totals)
        }, onProblem: { [weak self] problem in
            self?.apply(problem)
        })
    }

    package func stop() {
        source.stop()
    }

    package func apply(_ totals: TrackerTotals) {
        self.totals = totals
        self.problem = nil
    }

    package func apply(_ problem: ChannelProblem) {
        self.problem = problem
    }
}
