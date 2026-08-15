import Foundation
import Observation

/** The tray's live view of other applications' menu bar items. */
@MainActor
@Observable
final class MenuBarItemRegistry {
    private(set) var items: [MenuBarItem] = []

    private let source: any MenuBarItemsPort
    private var lastSweep: Date?

    init(source: any MenuBarItemsPort) {
        self.source = source
    }

    func refresh(now: Date = Date()) {
        if let lastSweep, now.timeIntervalSince(lastSweep) < TrayMetrics.sweepInterval {
            return
        }
        lastSweep = now
        items = MenuBarItemPolicy.hostable(source.items())
    }

    func press(_ item: MenuBarItem) {
        _ = source.press(item)
    }

    func menu(for item: MenuBarItem) -> [MenuBarEntry] {
        source.menu(for: item)
    }

    func invoke(_ entry: MenuBarEntry, in item: MenuBarItem) {
        source.invoke(entry, in: item)
    }
}
