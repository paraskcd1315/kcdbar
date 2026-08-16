import Observation

@MainActor
@Observable
package final class LoginItemState {
    package private(set) var isEnabled: Bool

    private let port: any LoginItemPort

    package init(port: any LoginItemPort) {
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
