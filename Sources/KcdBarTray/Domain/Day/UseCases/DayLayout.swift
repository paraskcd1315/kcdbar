import Foundation

/** Places a day's entries on the hour grid, dividing the width among whatever ran at the same time. */
package enum DayLayout {
    package static let dayLength: Double = 86400

    private static let dayMinutes: Double = 1440

    package static func blocks(
        of entries: [DayEntry],
        on day: Date,
        in calendar: Calendar = .current,
        at now: Date
    ) -> [DayBlock] {
        let opens = calendar.startOfDay(for: day)
        let closes = opens.addingTimeInterval(dayLength)

        let placed =
            entries
            .compactMap { entry -> (DayEntry, Double, Double)? in
                let ends = entry.endedAt(by: now)

                guard entry.startedAt < closes, ends > opens else { return nil }

                let from = max(entry.startedAt, opens).timeIntervalSince(opens) / dayLength
                let to = min(ends, closes).timeIntervalSince(opens) / dayLength

                return (entry, from, max(0, to - from))
            }
            .sorted { $0.1 == $1.1 ? $0.0.id < $1.0.id : $0.1 < $1.1 }

        return columns(placed)
    }

    /** A run of entries that overlap in a chain shares one width; a gap starts a fresh division. */
    private static func columns(_ placed: [(DayEntry, Double, Double)]) -> [DayBlock] {
        var built: [DayBlock] = []
        var cluster: [(DayEntry, Double, Double, Int)] = []
        var ends: [Int] = []
        var clusterEnd = Int.min

        func flush() {
            let width = max(1, ends.count)

            built += cluster.map {
                DayBlock(entry: $0.0, top: $0.1, height: $0.2, column: $0.3, columns: width)
            }

            cluster = []
            ends = []
            clusterEnd = Int.min
        }

        for (entry, top, height) in placed {
            let from = minute(top)
            let to = minute(top + height)

            if from >= clusterEnd, !cluster.isEmpty { flush() }

            let free = ends.firstIndex { $0 <= from }
            let column = free ?? ends.count

            if let free {
                ends[free] = to
            } else {
                ends.append(to)
            }

            cluster.append((entry, top, height, column))
            clusterEnd = max(clusterEnd, to)
        }

        flush()

        return built
    }

    /** Entries share their width only where they overlap on the minute the grid states. */
    private static func minute(_ fraction: Double) -> Int {
        Int(fraction * dayMinutes)
    }
}
