/** A tmux pane address, split into the two targets selecting it takes. */
package struct TmuxTarget: Equatable, Sendable {
    package let window: String
    package let pane: String

    package init(window: String, pane: String) {
        self.window = window
        self.pane = pane
    }

    package static func of(_ address: String) -> TmuxTarget? {
        let trimmed = address.trimmingCharacters(in: .whitespaces)

        guard let split = trimmed.lastIndex(of: ".") else { return nil }

        let window = String(trimmed[trimmed.startIndex..<split])
        let pane = String(trimmed[trimmed.index(after: split)...])

        guard !window.isEmpty, !pane.isEmpty else { return nil }

        return TmuxTarget(window: window, pane: pane)
    }
}
