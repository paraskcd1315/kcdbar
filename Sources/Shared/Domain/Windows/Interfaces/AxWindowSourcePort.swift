import Foundation

protocol AxWindowSourcePort: Sendable {
    func windows(forPids pids: [pid_t]) -> [AxWindowRecord]
}
