import CoreGraphics
import Observation

/** Which entry the pointer rests on, where it sits inside the panel, and whether the tooltip holds it. */
@MainActor
@Observable
package final class TaskbarHoverState {
    package private(set) var entry: TaskbarEntryModel?
    package private(set) var frame: CGRect = .zero

    @ObservationIgnored private let linger: Duration
    @ObservationIgnored private var isOverTooltip = false
    @ObservationIgnored private var leaving: Task<Void, Never>?

    package init(linger: Duration = TaskbarMetrics.tooltipLinger) {
        self.linger = linger
    }

    package func enter(_ entry: TaskbarEntryModel, at frame: CGRect) {
        cancelLeaving()
        self.entry = entry
        self.frame = frame
    }

    package func move(_ entry: TaskbarEntryModel, to frame: CGRect) {
        guard self.entry?.id == entry.id else { return }

        self.frame = frame
    }

    package func leave(_ entry: TaskbarEntryModel) {
        guard self.entry?.id == entry.id else { return }

        scheduleLeaving()
    }

    package func holdOverTooltip() {
        isOverTooltip = true
        cancelLeaving()
    }

    package func releaseTooltip() {
        isOverTooltip = false
        scheduleLeaving()
    }

    package func isShowing(_ entry: TaskbarEntryModel) -> Bool {
        self.entry?.id == entry.id
    }

    private func scheduleLeaving() {
        cancelLeaving()
        leaving = Task { [weak self, linger] in
            try? await Task.sleep(for: linger)
            guard !Task.isCancelled else { return }

            self?.settleLeaving()
        }
    }

    private func settleLeaving() {
        leaving = nil
        guard !isOverTooltip else { return }

        entry = nil
    }

    private func cancelLeaving() {
        leaving?.cancel()
        leaving = nil
    }
}
