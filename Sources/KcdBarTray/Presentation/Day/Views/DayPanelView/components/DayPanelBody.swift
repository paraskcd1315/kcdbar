import KcdBarDesignSystem
import SwiftUI

package struct DayPanelBody: View {
    package let day: TrackerDay?
    package let now: Date
    package let onOpen: (DayEntry) -> Void

    package init(day: TrackerDay?, now: Date, onOpen: @escaping (DayEntry) -> Void) {
        self.day = day
        self.now = now
        self.onOpen = onOpen
    }

    package var body: some View {
        switch DayPanelReading.of(day, at: now) {
        case .absent: DayPanelNotice(message: "day.absent")
        case .stale: DayPanelNotice(message: "day.stale")
        case .empty: DayPanelNotice(message: "day.empty")
        case .tracked(let tracked):
            DayGrid(
                day: tracked,
                blocks: DayLayout.blocks(of: tracked.entries, on: tracked.day, at: now),
                now: now,
                showsNow: true,
                onOpen: onOpen
            )
        }
    }
}
