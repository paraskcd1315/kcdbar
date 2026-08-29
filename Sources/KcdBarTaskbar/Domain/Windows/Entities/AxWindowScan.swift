// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
