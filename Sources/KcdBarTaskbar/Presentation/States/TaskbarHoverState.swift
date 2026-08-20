import CoreGraphics
import Observation

/** Which entry the pointer rests on, and where it sits inside the panel. */
@MainActor
@Observable
package final class TaskbarHoverState {
    package private(set) var entry: TaskbarEntryModel?
    package private(set) var frame: CGRect = .zero

    package init() {}

    package func enter(_ entry: TaskbarEntryModel, at frame: CGRect) {
        self.entry = entry
        self.frame = frame
    }

    package func move(_ entry: TaskbarEntryModel, to frame: CGRect) {
        guard self.entry?.id == entry.id else { return }

        self.frame = frame
    }

    package func leave(_ entry: TaskbarEntryModel) {
        guard self.entry?.id == entry.id else { return }

        self.entry = nil
    }
}
