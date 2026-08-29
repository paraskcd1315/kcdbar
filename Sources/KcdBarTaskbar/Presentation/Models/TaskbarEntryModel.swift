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
