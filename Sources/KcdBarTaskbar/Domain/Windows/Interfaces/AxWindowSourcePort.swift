import Foundation

package protocol AxWindowSourcePort: Sendable {
    func windows(forPids pids: [pid_t]) -> [AxWindowRecord]
}
