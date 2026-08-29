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

/** How often an application was launched from the bar or the Start menu, and when it last was. */
package struct ApplicationUsage: Equatable, Sendable, Identifiable {
    package var bundleIdentifier: String
    package var count: Int
    package var lastLaunchedAt: Date

    package init(bundleIdentifier: String, count: Int, lastLaunchedAt: Date) {
        self.bundleIdentifier = bundleIdentifier
        self.count = count
        self.lastLaunchedAt = lastLaunchedAt
    }

    package var id: String { bundleIdentifier }
}
