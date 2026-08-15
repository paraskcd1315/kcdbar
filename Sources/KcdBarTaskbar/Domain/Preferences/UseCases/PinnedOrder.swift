/** The pinned apps in the taskbar's own order, or nothing when the two disagree. */
package enum PinnedOrder {
    package static func reordered(_ apps: [PinnedApp], byKeys keys: [String]) -> [PinnedApp]? {
        let byKey = Dictionary(
            uniqueKeysWithValues: apps.map { (TaskbarOrdering.applicationKey($0.bundleIdentifier), $0) }
        )
        let ordered = keys.compactMap { byKey[$0] }
        guard ordered.count == apps.count else { return nil }

        return ordered
    }
}
