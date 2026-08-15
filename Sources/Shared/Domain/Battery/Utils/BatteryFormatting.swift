import Foundation

enum BatteryFormatting {
    static func remaining(minutes: Int) -> String {
        let hours = minutes / 60
        let rest = minutes % 60
        guard hours > 0 else { return "\(rest) min" }

        return "\(hours) h \(rest) min"
    }
}
