import Foundation

package enum ClockFormatting {
    package static func naturalDate(_ date: Date, calendar: Calendar = .current) -> String {
        let day = calendar.component(.day, from: date)
        let ordinalDay = ordinal.string(from: NSNumber(value: day)) ?? "\(day)"
        let monthAndYear = date.formatted(.dateTime.month(.abbreviated).year())

        return "\(ordinalDay) \(monthAndYear)"
    }

    private static let ordinal: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal

        return formatter
    }()
}
