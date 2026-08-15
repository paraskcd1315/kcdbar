import Foundation

enum TaskbarEntryGrouping {
    static func groups(from entries: [TaskbarEntryModel]) -> [TaskbarEntryGroup] {
        var groups: [TaskbarEntryGroup] = []

        for entry in entries {
            let key = entry.orderingKey
            if let last = groups.last, last.id == key {
                groups[groups.count - 1] = TaskbarEntryGroup(id: key, entries: last.entries + [entry])
            } else {
                groups.append(TaskbarEntryGroup(id: key, entries: [entry]))
            }
        }

        return groups
    }
}
