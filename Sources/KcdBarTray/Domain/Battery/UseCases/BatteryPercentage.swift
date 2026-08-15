/** The charge percentage a capacity reading represents. */
enum BatteryPercentage {
    static func of(capacity: Int, maximum: Int) -> Int {
        guard maximum > 0 else { return 0 }

        return Int((Double(capacity) / Double(maximum) * BatteryMetrics.fullCharge).rounded())
    }
}
