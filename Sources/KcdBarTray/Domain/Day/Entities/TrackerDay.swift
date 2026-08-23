import Foundation

/** One day of tracked time, dated so a snapshot nobody replaced overnight cannot read as today. */
package struct TrackerDay: Equatable, Sendable {
    package let day: Date
    package let entries: [DayEntry]
    package let projects: [DayProject]

    package init(day: Date, entries: [DayEntry], projects: [DayProject]) {
        self.day = day
        self.entries = entries
        self.projects = projects
    }

    package func project(of entry: DayEntry) -> DayProject? {
        guard let id = entry.projectId else { return nil }

        return projects.first { $0.id == id }
    }

    package func covers(_ moment: Date, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(day, inSameDayAs: moment)
    }
}
