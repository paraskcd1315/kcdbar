import Foundation

/** The single rule for where a dragged key lands: it takes the target's slot. */
enum OrderedKeys {
    static func moving(_ key: String, onto target: String, in keys: [String]) -> [String] {
        guard key != target, keys.contains(key), let slot = keys.firstIndex(of: target) else {
            return keys
        }

        var remaining = keys.filter { $0 != key }
        remaining.insert(key, at: min(slot, remaining.count))

        return remaining
    }

    static func deduped(_ keys: [String]) -> [String] {
        var seen: Set<String> = []

        return keys.filter { seen.insert($0).inserted }
    }
}
