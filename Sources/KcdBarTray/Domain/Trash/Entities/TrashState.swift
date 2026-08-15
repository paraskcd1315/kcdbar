package struct TrashState: Equatable {
    package let isEmpty: Bool

    package init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }

    package static let empty = TrashState(isEmpty: true)
}
