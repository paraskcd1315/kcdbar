package enum TaskbarEntryFolding {
    package static func folded(_ entries: [TaskbarEntryModel], grouping: BarGrouping) -> [TaskbarEntryModel] {
        guard grouping == .perApplication else { return entries }

        var claimed: Set<String> = []
        var folded: [TaskbarEntryModel] = []

        for entry in entries {
            guard let identifier = entry.bundleIdentifier else {
                folded.append(entry)
                continue
            }
            guard !claimed.contains(identifier) else { continue }

            claimed.insert(identifier)
            folded.append(
                representative(
                    of: entries.filter { $0.bundleIdentifier == identifier },
                    fallback: entry
                )
            )
        }
        return folded
    }

    private static func representative(
        of siblings: [TaskbarEntryModel],
        fallback: TaskbarEntryModel
    ) -> TaskbarEntryModel {
        guard siblings.count > 1 else { return siblings.first ?? fallback }

        let chosen = siblings.first(where: \.isFrontmost) ?? siblings.first ?? fallback

        return TaskbarEntryModel(
            id: chosen.id,
            title: chosen.applicationName.isEmpty ? chosen.title : chosen.applicationName,
            applicationName: chosen.applicationName,
            bundleIdentifier: chosen.bundleIdentifier,
            icon: chosen.icon,
            isMinimized: siblings.allSatisfy(\.isMinimized),
            isFrontmost: siblings.contains(where: \.isFrontmost),
            isPinned: siblings.contains(where: \.isPinned),
            isLauncher: chosen.isLauncher,
            isRunning: siblings.contains(where: \.isRunning),
            instanceCount: chosen.instanceCount,
            instancesOnThisDisplay: chosen.instancesOnThisDisplay,
            previewWindowIds: siblings.flatMap(\.previewWindowIds)
        )
    }
}
