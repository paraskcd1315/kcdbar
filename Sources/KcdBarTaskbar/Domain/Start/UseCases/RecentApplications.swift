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

/** The applications reached for most often, newest first when they are reached for as often. */
package enum RecentApplications {
    package static func ranked(
        _ usage: [ApplicationUsage],
        among installed: [InstalledApplication],
        limit: Int = StartMenuMetrics.recentLimit
    ) -> [InstalledApplication] {
        let known = Dictionary(
            installed.map { ($0.bundleIdentifier, $0) },
            uniquingKeysWith: { first, _ in first }
        )

        return usage
            .sorted {
                guard $0.count == $1.count else { return $0.count > $1.count }

                return $0.lastLaunchedAt > $1.lastLaunchedAt
            }
            .prefix(limit)
            .compactMap { known[$0.bundleIdentifier] }
    }
}
