import Foundation

@testable import KcdBarTaskbar

final class RecordingDockControl: DockControlPort, @unchecked Sendable {
    private(set) var written: [[DockDefault]] = []
    private(set) var restarts = 0

    let held: DockSettingsSnapshot

    init(held: DockSettingsSnapshot) {
        self.held = held
    }

    func settings() -> DockSettingsSnapshot {
        held
    }

    func write(_ defaults: [DockDefault]) {
        guard !defaults.isEmpty else { return }

        written.append(defaults)
    }

    func restart() {
        restarts += 1
    }
}
