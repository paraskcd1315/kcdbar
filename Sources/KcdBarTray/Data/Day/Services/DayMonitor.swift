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
