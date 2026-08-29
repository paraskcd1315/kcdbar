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
