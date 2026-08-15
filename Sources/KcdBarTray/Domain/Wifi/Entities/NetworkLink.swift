package enum NetworkLink: Equatable {
    case wifi
    case ethernet(name: String)
    case none

    package var isWired: Bool {
        if case .ethernet = self { return true }

        return false
    }
}
