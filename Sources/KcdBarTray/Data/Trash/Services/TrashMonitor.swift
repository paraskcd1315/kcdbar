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
import SwiftUI

/** The bar's live view of the trash. */
@MainActor
@Observable
package final class TrashMonitor {
    package private(set) var state: TrashState = .empty

    private let source: any TrashPort
    private let confirmation: any TrashConfirmationPort

    package init(source: any TrashPort, confirmation: any TrashConfirmationPort) {
        self.source = source
        self.confirmation = confirmation
    }

    package var icon: Image? {
        source.icon(isEmpty: state.isEmpty)
    }

    package func start() {
        refresh()
        source.watch { [weak self] in self?.refresh() }
    }

    package func refresh() {
        state = source.state()
    }

    package func open() {
        source.open()
    }

    package func empty() {
        guard confirmation.confirmEmpty() else { return }

        source.empty()
        refresh()
    }
}
