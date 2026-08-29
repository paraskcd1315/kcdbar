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

/** A band of the Start menu's pinned pane. */
@Model
package final class StoredStartGroup {
    @Attribute(.unique) package var id: String
    package var title: String?
    package var titleKey: String?
    package var order: Int
    package var isCollapsed: Bool

    package init(id: String, title: String?, titleKey: String?, order: Int, isCollapsed: Bool) {
        self.id = id
        self.title = title
        self.titleKey = titleKey
        self.order = order
        self.isCollapsed = isCollapsed
    }
}
