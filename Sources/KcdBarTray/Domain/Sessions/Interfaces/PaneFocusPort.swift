package protocol PaneFocusPort: Sendable {
    func focus(pane: String) async -> Bool
}
