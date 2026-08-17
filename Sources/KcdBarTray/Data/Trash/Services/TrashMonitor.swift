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
