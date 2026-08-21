/** The three parts of a KCDBar version: a milestone, a feature within it, and a fix within that. */
package struct AppVersionComponents: Sendable, Equatable {
    package let milestone: Int
    package let feature: Int
    package let fix: Int

    package init(milestone: Int, feature: Int, fix: Int) {
        self.milestone = milestone
        self.feature = feature
        self.fix = fix
    }

    package init?(_ marketing: String) {
        let parts = marketing.split(separator: ".", omittingEmptySubsequences: false)
        guard parts.count == AppVersionMetrics.partCount else { return nil }

        let numbers = parts.compactMap { Int($0) }
        guard numbers.count == AppVersionMetrics.partCount, numbers.allSatisfy({ $0 >= 0 }) else {
            return nil
        }

        self.init(milestone: numbers[0], feature: numbers[1], fix: numbers[2])
    }

    package var text: String {
        "\(milestone).\(feature).\(fix)"
    }

    package var kind: AppReleaseKind {
        if fix > 0 { return .fix }
        if feature > 0 { return .feature }

        return .milestone
    }
}
