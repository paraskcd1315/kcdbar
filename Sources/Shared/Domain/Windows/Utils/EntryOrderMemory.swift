import Foundation

/** The order the bar's entries are shown in, keyed by ordering key. */
@MainActor
@Observable
final class EntryOrderMemory {
    private(set) var keys: [String] = []

    var ranks: [String: Int] {
        Dictionary(uniqueKeysWithValues: keys.enumerated().map { ($0.element, $0.offset) })
    }

    func note(keys incoming: [String]) {
        let live = Set(incoming)
        keys.removeAll { !live.contains($0) }

        let held = Set(keys)
        keys.append(contentsOf: incoming.filter { !held.contains($0) })
    }

    func seed(keys leading: [String]) {
        let held = Set(keys)
        keys = leading.filter(held.contains) + keys.filter { !leading.contains($0) }
    }

    func move(key: String, before target: String?) {
        guard key != target, let from = keys.firstIndex(of: key) else { return }

        keys.remove(at: from)

        guard let target, let to = keys.firstIndex(of: target) else {
            keys.append(key)
            return
        }
        keys.insert(key, at: to)
    }
}
