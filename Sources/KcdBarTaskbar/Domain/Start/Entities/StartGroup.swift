/** A band of the Start menu's pinned pane, named either by the user or by where it came from. */
package struct StartGroup: Equatable, Sendable, Identifiable {
    package var id: String
    package var title: String?
    package var titleKey: String?
    package var order: Int
    package var isCollapsed: Bool

    package init(
        id: String,
        title: String? = nil,
        titleKey: String? = nil,
        order: Int,
        isCollapsed: Bool = false
    ) {
        self.id = id
        self.title = title
        self.titleKey = titleKey
        self.order = order
        self.isCollapsed = isCollapsed
    }
}
