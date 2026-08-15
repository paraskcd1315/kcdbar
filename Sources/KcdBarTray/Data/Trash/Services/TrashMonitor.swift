import Observation
import SwiftUI

/** The bar's live view of the trash. */
@MainActor
@Observable
package final class TrashMonitor {
    package private(set) var state: TrashState = .empty

    private let source: any TrashPort

    package init(source: any TrashPort) {
        self.source = source
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
}
