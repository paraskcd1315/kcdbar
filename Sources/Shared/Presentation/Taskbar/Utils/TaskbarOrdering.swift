import Foundation

enum TaskbarOrdering {
    static func orderingKey(bundleIdentifier: String?, entryId: String, isPinned: Bool) -> String {
        guard isPinned, let bundleIdentifier else { return entryId }

        return "pin:\(bundleIdentifier)"
    }

    static func ordered(
        entries: [TaskbarEntryModel],
        ranks: [String: Int]
    ) -> [TaskbarEntryModel] {
        entries.sorted { first, second in
            ranks[first.orderingKey, default: .max] < ranks[second.orderingKey, default: .max]
        }
    }
}
