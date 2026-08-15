/** Where the week stands: the five figures that are published, and everything derived from them. */
package struct TrackerPace: Equatable, Sendable {
    package let targetSeconds: Int
    package let workedSeconds: Int
    package let workedTodaySeconds: Int
    package let daysLeft: Int
    package let minimumDaySeconds: Int

    package init(
        targetSeconds: Int,
        workedSeconds: Int,
        workedTodaySeconds: Int,
        daysLeft: Int,
        minimumDaySeconds: Int
    ) {
        self.targetSeconds = targetSeconds
        self.workedSeconds = workedSeconds
        self.workedTodaySeconds = workedTodaySeconds
        self.daysLeft = daysLeft
        self.minimumDaySeconds = minimumDaySeconds
    }

    package var remainingSeconds: Int { max(0, targetSeconds - workedSeconds) }

    package var isOver: Bool { workedSeconds > targetSeconds }

    package var overSeconds: Int { max(0, workedSeconds - targetSeconds) }

    package var todaySeconds: Int {
        guard daysLeft > 0 else { return 0 }

        let evenly = remainingSeconds / daysLeft

        return min(remainingSeconds, max(minimumDaySeconds, evenly))
    }

    package var leftTodaySeconds: Int { max(0, todaySeconds - workedTodaySeconds) }

    package var isBelowFloor: Bool {
        workedTodaySeconds > 0 && workedTodaySeconds < min(minimumDaySeconds, remainingSeconds)
    }
}
