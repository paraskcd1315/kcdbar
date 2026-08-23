import Foundation

/** One day of tracked time, as the channel writes it. */
package struct DaySignal: Codable, Sendable, Equatable {
    package let day: Date
    package let entries: [DayEntrySignal]
    package let projects: [DayProjectSignal]

    package func toEntity() -> TrackerDay {
        TrackerDay(
            day: day,
            entries: entries.map { $0.toEntity() },
            projects: projects.map { $0.toEntity() }
        )
    }
}
