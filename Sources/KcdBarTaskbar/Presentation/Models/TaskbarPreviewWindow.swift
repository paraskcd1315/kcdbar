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

import CoreGraphics

/** One window an entry can preview — its id, the size its thumbnail keeps the shape of, and what the tile says about it. */
package struct TaskbarPreviewWindow: Identifiable, Equatable, Sendable {
    package let id: CGWindowID
    package let size: CGSize
    package var displayName: String? = nil
    package var isFullScreen: Bool = false
    package var title: String? = nil
    package var profile: String? = nil
    package var isOnInactiveSpace: Bool = false

    package init(
        id: CGWindowID,
        size: CGSize,
        displayName: String? = nil,
        isFullScreen: Bool = false,
        title: String? = nil,
        profile: String? = nil,
        isOnInactiveSpace: Bool = false
    ) {
        self.id = id
        self.size = size
        self.displayName = displayName
        self.isFullScreen = isFullScreen
        self.title = title
        self.profile = profile
        self.isOnInactiveSpace = isOnInactiveSpace
    }
}
