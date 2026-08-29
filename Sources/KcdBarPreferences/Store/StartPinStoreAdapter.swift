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
