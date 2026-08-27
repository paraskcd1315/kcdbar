import Foundation
@testable import KcdBarTaskbar

struct StubRunningApplications: RunningApplicationsPort {
    func currentApplications() -> [RunningApplication] {
        []
    }

    var frontmostPid: pid_t? { nil }
}
