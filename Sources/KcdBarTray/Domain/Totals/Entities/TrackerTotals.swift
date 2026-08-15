/** What today and this week come to for one tracker. */
package struct TrackerTotals: Equatable, Sendable {
    package let todaySeconds: Int
    package let weekSeconds: Int
    package let pace: TrackerPace?

    package init(todaySeconds: Int, weekSeconds: Int, pace: TrackerPace?) {
        self.todaySeconds = todaySeconds
        self.weekSeconds = weekSeconds
        self.pace = pace
    }
}
