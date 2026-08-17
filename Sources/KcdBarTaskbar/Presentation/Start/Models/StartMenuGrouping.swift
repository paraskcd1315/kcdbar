/** How the all-applications list is banded. */
package enum StartMenuGrouping: String, CaseIterable, Sendable {
    case alphabetical
    case category

    package var titleKey: String { StartMenuMetrics.groupingTitlePrefix + rawValue }
}
