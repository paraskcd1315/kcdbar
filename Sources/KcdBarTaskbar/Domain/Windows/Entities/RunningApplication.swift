import Foundation

package struct RunningApplication: Equatable, Sendable {
    package let pid: pid_t
    package let bundleIdentifier: String?
    package let localizedName: String?
    package var launchedAt: Date? = nil
}
