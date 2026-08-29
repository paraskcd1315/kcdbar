// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
            previewWindows: TaskbarPreviewWindows.unique(siblings.flatMap(\.previewWindows))
        )
    }
}
