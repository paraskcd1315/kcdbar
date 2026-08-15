import Foundation

/** The order entries were first seen in. */
@MainActor
final class EntryOrderMemory {
    private var sequence: [String: Int] = [:]
    private var next = 0

    var sequences: [String: Int] { sequence }

    func note(entryIds: [String]) {
        for id in entryIds where sequence[id] == nil {
            sequence[id] = next
            next += 1
        }
        let live = Set(entryIds)
        sequence = sequence.filter { live.contains($0.key) }
    }
}
