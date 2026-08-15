import Foundation

enum TaskbarDragReorder {
    static func preview(
        entries: [TaskbarEntryModel],
        dragging: String?,
        over: String?
    ) -> [TaskbarEntryModel] {
        guard let dragging, let over, dragging != over else { return entries }

        let keys = slots(in: entries)
        let moved = OrderedKeys.moving(dragging, onto: over, in: keys)
        guard moved != keys else { return entries }

        let grouped = Dictionary(grouping: entries, by: \.orderingKey)

        return moved.flatMap { grouped[$0] ?? [] }
    }

    private static func slots(in entries: [TaskbarEntryModel]) -> [String] {
        var keys: [String] = []
        for entry in entries where !keys.contains(entry.orderingKey) {
            keys.append(entry.orderingKey)
        }

        return keys
    }
}
