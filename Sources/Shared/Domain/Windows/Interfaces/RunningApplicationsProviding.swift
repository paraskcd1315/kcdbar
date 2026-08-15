import Foundation

protocol RunningApplicationsProviding: Sendable {
    func currentApplications() -> [RunningApplication]
    var frontmostPid: pid_t? { get }
}
