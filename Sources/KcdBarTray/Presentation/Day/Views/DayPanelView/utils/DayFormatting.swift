import Foundation

package enum DayFormatting {
    package static func heading(_ day: Date) -> String {
        day.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
    }

    package static func hour(_ hour: Int) -> String {
        String(format: "%02d", hour)
    }

    package static func clock(_ moment: Date) -> String {
        moment.formatted(.dateTime.hour().minute())
    }

    package static func range(from started: Date, to ended: Date) -> String {
        "\(clock(started)) – \(clock(ended))"
    }

    package static func label(for entry: DayEntry) -> String {
        entry.jiraKey ?? entry.detail
    }
}
