import Foundation
@testable import KcdBarTaskbar

@MainActor
struct StubMenuExtraOwnership: MenuExtraOwnershipPort {
    let answer: Bool?

    func hasMenuExtra(pid: pid_t) -> Bool? {
        answer
    }
}
