import Foundation

struct RunningApplication: Equatable, Sendable {
    let pid: pid_t
    let bundleIdentifier: String?
    let localizedName: String?
}
