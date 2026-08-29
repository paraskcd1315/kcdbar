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
