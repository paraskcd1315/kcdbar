// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
