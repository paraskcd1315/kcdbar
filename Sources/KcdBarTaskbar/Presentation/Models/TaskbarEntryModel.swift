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
import SwiftUI

package struct TaskbarEntryModel: Identifiable, Equatable {
    package let id: String
    package let title: String
    package let applicationName: String
    package let bundleIdentifier: String?
    package let icon: Image?
    package let isMinimized: Bool
    package let isFrontmost: Bool
    package let isPinned: Bool
    package let isLauncher: Bool
    package let isRunning: Bool
    package let instanceCount: Int
    package let instancesOnThisDisplay: Int
    package let previewWindows: [TaskbarPreviewWindow]

    package var fullScreenCount: Int {
        previewWindows.filter(\.isFullScreen).count
    }

    package var isFullScreen: Bool {
        fullScreenCount > 0
    }

    package var cyclesWindows: Bool {
        previewWindows.count > 1
    }

    package var orderingKey: String {
        TaskbarOrdering.orderingKey(bundleIdentifier: bundleIdentifier, entryId: id)
    }

    package static func == (lhs: TaskbarEntryModel, rhs: TaskbarEntryModel) -> Bool {
        lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.applicationName == rhs.applicationName
            && lhs.bundleIdentifier == rhs.bundleIdentifier
            && lhs.isMinimized == rhs.isMinimized
            && lhs.isFrontmost == rhs.isFrontmost
            && lhs.isPinned == rhs.isPinned
            && lhs.isLauncher == rhs.isLauncher
            && lhs.isRunning == rhs.isRunning
            && lhs.instanceCount == rhs.instanceCount
            && lhs.instancesOnThisDisplay == rhs.instancesOnThisDisplay
            && lhs.previewWindows == rhs.previewWindows
    }
}
