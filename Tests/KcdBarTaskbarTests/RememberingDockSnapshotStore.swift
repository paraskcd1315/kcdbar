import Foundation

@testable import KcdBarTaskbar

actor RememberingDockSnapshotStore: DockSnapshotStorePort {
    private var held: DockSettingsSnapshot?
    private(set) var clears = 0

    init(held: DockSettingsSnapshot? = nil) {
        self.held = held
    }

    func snapshot() async -> DockSettingsSnapshot? {
        held
    }

    func remember(_ snapshot: DockSettingsSnapshot) async {
        held = snapshot
    }

    func clear() async {
        held = nil
        clears += 1
    }
}
