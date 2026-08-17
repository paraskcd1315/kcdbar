/** The applications reached for most often, newest first when they are reached for as often. */
package enum RecentApplications {
    package static func ranked(
        _ usage: [ApplicationUsage],
        among installed: [InstalledApplication],
        limit: Int = StartMenuMetrics.recentLimit
    ) -> [InstalledApplication] {
        let known = Dictionary(
            installed.map { ($0.bundleIdentifier, $0) },
            uniquingKeysWith: { first, _ in first }
        )

        return usage
            .sorted {
                guard $0.count == $1.count else { return $0.count > $1.count }

                return $0.lastLaunchedAt > $1.lastLaunchedAt
            }
            .prefix(limit)
            .compactMap { known[$0.bundleIdentifier] }
    }
}
