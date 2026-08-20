import Observation

@MainActor
@Observable
package final class StageManagerState {
    package private(set) var isEnabled: Bool

    private let port: any StageManagerPort

    package init(port: any StageManagerPort) {
        self.port = port
        isEnabled = port.isEnabled
    }

    package func refresh() {
        isEnabled = port.isEnabled
    }

    package func toggle() {
        port.setEnabled(!isEnabled)
        refresh()
    }
}
