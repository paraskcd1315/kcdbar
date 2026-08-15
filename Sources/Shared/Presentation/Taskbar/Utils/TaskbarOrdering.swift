import Foundation

enum TaskbarOrdering {
    static func ordered(
        entries: [TaskbarEntryModel],
        pinnedApps: [PinnedApp],
        sequences: [String: Int]
    ) -> [TaskbarEntryModel] {
        let pinnedRank = Dictionary(
            uniqueKeysWithValues: pinnedApps.enumerated().map { ($0.element.bundleIdentifier, $0.offset) }
        )

        return entries.sorted { first, second in
            let firstPin = first.bundleIdentifier.flatMap { pinnedRank[$0] }
            let secondPin = second.bundleIdentifier.flatMap { pinnedRank[$0] }

            switch (firstPin, secondPin) {
            case let (.some(left), .some(right)) where left != right:
                return left < right
            case (.some, .none):
                return true
            case (.none, .some):
                return false
            default:
                return sequences[first.id, default: .max] < sequences[second.id, default: .max]
            }
        }
    }
}
