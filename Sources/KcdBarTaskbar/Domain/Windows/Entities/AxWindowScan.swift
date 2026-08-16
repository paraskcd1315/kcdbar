import Foundation

package struct AxWindowScan: Equatable, Sendable {
    package let records: [AxWindowRecord]
    package let answeredPids: Set<pid_t>

    package init(records: [AxWindowRecord], answeredPids: Set<pid_t>) {
        self.records = records
        self.answeredPids = answeredPids
    }

    package static let silent = AxWindowScan(records: [], answeredPids: [])

    package static func answered(_ records: [AxWindowRecord]) -> AxWindowScan {
        AxWindowScan(records: records, answeredPids: Set(records.map(\.ownerPid)))
    }
}
