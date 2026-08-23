import Foundation

/** What the panel has to say, so no view decides for itself whether a snapshot is still today's. */
package enum DayPanelReading: Equatable {
    case absent
    case stale
    case empty
    case tracked(TrackerDay)

    package static func of(
        _ day: TrackerDay?,
        at moment: Date,
        in calendar: Calendar = .current
    ) -> DayPanelReading {
        guard let day else { return .absent }
        guard day.covers(moment, in: calendar) else { return .stale }
        guard !day.entries.isEmpty else { return .empty }

        return .tracked(day)
    }
}
