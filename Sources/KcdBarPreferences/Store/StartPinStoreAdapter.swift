import KcdBarTaskbar

/** Presents the Start menu's own pin list through the same port the bar's list uses. */
package struct StartPinStoreAdapter: PinnedAppStorePort {
    private let store: any StartPinStorePort

    package init(store: any StartPinStorePort) {
        self.store = store
    }

    package func pinnedApps() async -> [PinnedApp] {
        await store.startPins()
    }

    package func pin(_ app: PinnedApp) async {
        await store.pinToStart(app)
    }

    package func unpin(bundleIdentifier: String) async {
        await store.unpinFromStart(bundleIdentifier: bundleIdentifier)
    }

    package func reorder(_ apps: [PinnedApp]) async {
        await store.reorderStartPins(apps)
    }
}
