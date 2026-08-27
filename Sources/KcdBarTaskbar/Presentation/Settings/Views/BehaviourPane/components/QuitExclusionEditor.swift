import SwiftUI

package struct QuitExclusionEditor: View {
    package let exclusions: QuitExclusionState
    package let candidates: [RunningApplication]

    package init(exclusions: QuitExclusionState, candidates: [RunningApplication]) {
        self.exclusions = exclusions
        self.candidates = candidates
    }

    package var body: some View {
        LabeledContent("settings.behaviour.quitExclusions") {
            Menu("settings.behaviour.quitExclusions.add") {
                ForEach(addable, id: \.pid) { application in
                    Button(application.localizedName ?? application.bundleIdentifier ?? "") {
                        Task { await exclusions.exclude(application) }
                    }
                }
            }
            .fixedSize()
        }
        if exclusions.exclusions.isEmpty {
            Text("settings.behaviour.quitExclusions.empty")
                .foregroundStyle(.secondary)
        }
        ForEach(exclusions.exclusions) { exclusion in
            LabeledContent(exclusion.displayName) {
                Button("settings.behaviour.quitExclusions.remove") {
                    Task { await exclusions.include(bundleIdentifier: exclusion.bundleIdentifier) }
                }
            }
        }
    }

    private var addable: [RunningApplication] {
        let excluded = exclusions.bundleIdentifiers

        return candidates
            .filter { application in
                guard let bundleIdentifier = application.bundleIdentifier else { return false }

                return ApplicationQuitPolicy.canQuit(bundleIdentifier: bundleIdentifier)
                    && !excluded.contains(bundleIdentifier)
            }
            .sorted { ($0.localizedName ?? "") < ($1.localizedName ?? "") }
    }
}
