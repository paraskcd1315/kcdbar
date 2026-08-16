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
