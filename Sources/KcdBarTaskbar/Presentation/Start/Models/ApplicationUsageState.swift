import Foundation
import Observation

/** What the user reaches for most, from the bar and from the Start menu alike. */
@MainActor
@Observable
package final class ApplicationUsageState {
    package private(set) var usage: [ApplicationUsage] = []
    package var isRecentCollapsed = false

    private let store: any ApplicationUsageStorePort

    package init(store: any ApplicationUsageStorePort) {
        self.store = store
    }

    package func load() async {
        usage = await store.applicationUsage()
    }

    package func note(launchOf bundleIdentifier: String) {
        Task {
            await store.recordLaunch(bundleIdentifier: bundleIdentifier, at: Date())
            await load()
        }
    }

    package func recents(among installed: [InstalledApplication]) -> [InstalledApplication] {
        RecentApplications.ranked(usage, among: installed)
    }
}
