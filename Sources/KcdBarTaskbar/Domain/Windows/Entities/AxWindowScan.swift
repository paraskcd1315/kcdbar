import CoreGraphics
import Foundation

package struct AxWindowScan: Equatable, Sendable {
    package let records: [AxWindowRecord]
    package let answeredPids: Set<pid_t>
    package let liveOmittedIds: Set<CGWindowID>

    package init(
        records: [AxWindowRecord],
        answeredPids: Set<pid_t>,
        liveOmittedIds: Set<CGWindowID> = []
    ) {
        self.records = records
        self.answeredPids = answeredPids
        self.liveOmittedIds = liveOmittedIds
    }

    package static let silent = AxWindowScan(records: [], answeredPids: [])

    package static func answered(_ records: [AxWindowRecord]) -> AxWindowScan {
        AxWindowScan(records: records, answeredPids: Set(records.map(\.ownerPid)))
    }
}
