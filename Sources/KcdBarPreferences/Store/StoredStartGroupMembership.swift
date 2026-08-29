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
import SwiftData

/** Which band a pinned application belongs to, kept apart from the pin so old pins survive. */
@Model
package final class StoredStartGroupMembership {
    @Attribute(.unique) package var bundleIdentifier: String
    package var groupId: String
    package var order: Int

    package init(bundleIdentifier: String, groupId: String, order: Int) {
        self.bundleIdentifier = bundleIdentifier
        self.groupId = groupId
        self.order = order
    }
}
