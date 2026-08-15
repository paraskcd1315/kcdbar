/** The day and the week, as the channel writes them. */
package struct TotalsSignal: Codable, Sendable, Equatable {
    package let todaySeconds: Int
    package let weekSeconds: Int
    package let pace: PaceSignal?

    package func toEntity() -> TrackerTotals {
        TrackerTotals(
            todaySeconds: todaySeconds,
            weekSeconds: weekSeconds,
            pace: pace?.toEntity()
        )
    }
}
