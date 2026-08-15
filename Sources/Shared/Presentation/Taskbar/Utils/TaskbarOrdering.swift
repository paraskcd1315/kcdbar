import Foundation

enum TaskbarOrdering {
    static func applicationKey(_ bundleIdentifier: String) -> String {
        "app:\(bundleIdentifier)"
    }

    static func orderingKey(bundleIdentifier: String?, entryId: String) -> String {
        guard let bundleIdentifier else { return entryId }

        return applicationKey(bundleIdentifier)
    }

    static func ordered(
        entries: [TaskbarEntryModel],
        ranks: [String: Int]
    ) -> [TaskbarEntryModel] {
        entries.sorted { first, second in
            let firstRank = ranks[first.orderingKey, default: .max]
            let secondRank = ranks[second.orderingKey, default: .max]

            guard firstRank == secondRank else { return firstRank < secondRank }

            let firstSeen = ranks[first.id, default: .max]
            let secondSeen = ranks[second.id, default: .max]

            guard firstSeen == secondSeen else { return firstSeen < secondSeen }

            return first.id < second.id
        }
    }
}
