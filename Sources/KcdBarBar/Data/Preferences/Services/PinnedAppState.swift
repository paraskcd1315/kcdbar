import Foundation
import Observation

/** The bar's live view of what is pinned, kept in step with the store. */
@MainActor
@Observable
package final class PinnedAppState {
    package private(set) var apps: [PinnedApp] = []

    private let store: any PinnedAppStorePort

    package init(store: any PinnedAppStorePort) {
        self.store = store
    }

    package func load() async {
        apps = await store.pinnedApps()
    }

    package func pin(bundleIdentifier: String, displayName: String) async {
        guard !apps.contains(where: { $0.bundleIdentifier == bundleIdentifier }) else { return }

        let app = PinnedApp(
            bundleIdentifier: bundleIdentifier,
            displayName: displayName,
            order: (apps.map(\.order).max() ?? -1) + 1
        )
        await store.pin(app)
        await load()
    }

    package func unpin(bundleIdentifier: String) async {
        await store.unpin(bundleIdentifier: bundleIdentifier)
        await load()
    }

    package func reorder(_ ordered: [PinnedApp]) async {
        let renumbered = ordered.enumerated().map { index, app in
            PinnedApp(
                bundleIdentifier: app.bundleIdentifier,
                displayName: app.displayName,
                order: index
            )
        }
        await store.reorder(renumbered)
        await load()
    }
}
