/** The week's five published figures. */
package struct PaceSignal: Codable, Sendable, Equatable {
    package let targetSeconds: Int
    package let workedSeconds: Int
    package let workedTodaySeconds: Int
    package let daysLeft: Int
    package let minimumDaySeconds: Int

    package func toEntity() -> TrackerPace {
        TrackerPace(
            targetSeconds: targetSeconds,
            workedSeconds: workedSeconds,
            workedTodaySeconds: workedTodaySeconds,
            daysLeft: daysLeft,
            minimumDaySeconds: minimumDaySeconds
        )
    }
}
