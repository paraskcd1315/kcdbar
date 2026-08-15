import Foundation

protocol RunningApplicationsPort: Sendable {
    func currentApplications() -> [RunningApplication]
    var frontmostPid: pid_t? { get }
}
