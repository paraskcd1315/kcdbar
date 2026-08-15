import SwiftUI

struct TaskbarEntryModel: Identifiable, Equatable {
    let id: String
    let title: String
    let applicationName: String
    let icon: Image?
    let isMinimized: Bool
    let isFrontmost: Bool

    static func == (lhs: TaskbarEntryModel, rhs: TaskbarEntryModel) -> Bool {
        lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.applicationName == rhs.applicationName
            && lhs.isMinimized == rhs.isMinimized
            && lhs.isFrontmost == rhs.isFrontmost
    }
}
