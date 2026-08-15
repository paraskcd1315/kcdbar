package struct NetworkDetailField: Identifiable, Equatable {
    package let id: String
    package let titleKey: String
    package let value: String

    package init(id: String, titleKey: String, value: String) {
        self.id = id
        self.titleKey = titleKey
        self.value = value
    }
}
