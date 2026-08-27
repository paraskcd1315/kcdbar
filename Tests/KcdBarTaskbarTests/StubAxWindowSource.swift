import Foundation
@testable import KcdBarTaskbar

struct StubAxWindowSource: AxWindowSourcePort {
    func windows(forPids pids: [pid_t]) -> AxWindowScan {
        .silent
    }
}
