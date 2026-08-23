/** The bar's per-display hidden, revealed and shown state. */
package struct BarPanelVisibilityState: Equatable, Sendable {
    package private(set) var hidden: Set<Int> = []
    package private(set) var revealed: Set<Int> = []
    package private(set) var shown: [Int: Bool] = [:]

    package init() {}

    package mutating func setHidden(_ ids: Set<Int>) {
        hidden = ids
        revealed.formIntersection(ids)
    }

    package mutating func setRevealed(_ revealed: Bool, for id: Int) {
        if revealed {
            self.revealed.insert(id)
        } else {
            self.revealed.remove(id)
        }
    }

    package mutating func record(showing: Bool, for id: Int) {
        shown[id] = showing
    }

    package mutating func forget(_ id: Int) {
        hidden.remove(id)
        revealed.remove(id)
        shown.removeValue(forKey: id)
    }

    package mutating func reset() {
        hidden = []
        revealed = []
        shown = [:]
    }

    package func wantsShown(_ id: Int) -> Bool {
        !hidden.contains(id) || revealed.contains(id)
    }

    package func isSettled(showing: Bool, for id: Int) -> Bool {
        shown[id] == showing
    }

    package func monitored(among ids: Set<Int>) -> Set<Int> {
        ids.filter { hidden.contains($0) || shown[$0] == false }
    }
}
