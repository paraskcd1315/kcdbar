import Observation

/** The applications the user keeps running after their last window closes, kept in step with the store. */
@MainActor
@Observable
package final class QuitExclusionState {
    package private(set) var exclusions: [QuitExclusion] = []

    private let store: any QuitExclusionStorePort

    package init(store: any QuitExclusionStorePort) {
        self.store = store
    }

    package var bundleIdentifiers: Set<String> {
        Set(exclusions.map(\.bundleIdentifier))
    }

    package func load() async {
        exclusions = await store.quitExclusions()
    }

    package func exclude(_ application: RunningApplication) async {
        guard let bundleIdentifier = application.bundleIdentifier,
              !bundleIdentifiers.contains(bundleIdentifier)
        else {
            return
        }
        await store.exclude(
            QuitExclusion(
                bundleIdentifier: bundleIdentifier,
                displayName: application.localizedName ?? bundleIdentifier
            )
        )
        await load()
    }

    package func include(bundleIdentifier: String) async {
        await store.include(bundleIdentifier: bundleIdentifier)
        await load()
    }
}
