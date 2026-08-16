import Foundation

/** How often an application was launched from the bar or the Start menu, and when it last was. */
package struct ApplicationUsage: Equatable, Sendable, Identifiable {
    package var bundleIdentifier: String
    package var count: Int
    package var lastLaunchedAt: Date

    package init(bundleIdentifier: String, count: Int, lastLaunchedAt: Date) {
        self.bundleIdentifier = bundleIdentifier
        self.count = count
        self.lastLaunchedAt = lastLaunchedAt
    }

    package var id: String { bundleIdentifier }
}
