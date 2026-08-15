import Foundation

protocol AxWindowSourceProviding: Sendable {
    func windows(forPids pids: [pid_t]) -> [AxWindowRecord]
}
