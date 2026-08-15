import SwiftUI

struct TaskbarEntryModel: Identifiable, Equatable {
    let id: String
    let title: String
    let applicationName: String
    let bundleIdentifier: String?
    let icon: Image?
    let isMinimized: Bool
    let isFrontmost: Bool
    let isPinned: Bool
    let isLauncher: Bool
    let instanceCount: Int

    var orderingKey: String {
        TaskbarOrdering.orderingKey(
            bundleIdentifier: bundleIdentifier,
            entryId: id,
            isPinned: isPinned
        )
    }

    static func == (lhs: TaskbarEntryModel, rhs: TaskbarEntryModel) -> Bool {
        lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.applicationName == rhs.applicationName
            && lhs.bundleIdentifier == rhs.bundleIdentifier
            && lhs.isMinimized == rhs.isMinimized
            && lhs.isFrontmost == rhs.isFrontmost
            && lhs.isPinned == rhs.isPinned
            && lhs.isLauncher == rhs.isLauncher
            && lhs.instanceCount == rhs.instanceCount
    }
}
