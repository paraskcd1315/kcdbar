import Foundation

/** Keeps the most recently published reading, so a tracker's stale file never overwrites the live one. */
package struct LatestTotals {
    private var newest: Date?

    package init() {}

    package mutating func accepts(_ publishedAt: Date) -> Bool {
        guard let newest, publishedAt < newest else {
            newest = publishedAt

            return true
        }

        return false
    }
}
