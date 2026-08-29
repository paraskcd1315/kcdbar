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

import Observation

/** The bar's live view of today and this week. */
@MainActor
@Observable
package final class TotalsMonitor {
    package private(set) var totals: TrackerTotals?
    package private(set) var problem: ChannelProblem?

    private let source: any TotalsSignalPort

    package init(source: any TotalsSignalPort) {
        self.source = source
    }

    package func start() {
        source.listen({ [weak self] totals in
            self?.apply(totals)
        }, onProblem: { [weak self] problem in
            self?.apply(problem)
        })
    }

    package func stop() {
        source.stop()
    }

    package func apply(_ totals: TrackerTotals) {
        self.totals = totals
        self.problem = nil
    }

    package func apply(_ problem: ChannelProblem) {
        self.problem = problem
    }
}
