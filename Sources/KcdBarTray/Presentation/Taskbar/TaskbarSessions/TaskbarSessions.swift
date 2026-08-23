import KcdBarDesignSystem
import SwiftUI

package struct TaskbarSessions: View {
    package let monitor: SessionsMonitor
    package let onOpen: () -> Void

    package init(monitor: SessionsMonitor, onOpen: @escaping () -> Void) {
        self.monitor = monitor
        self.onOpen = onOpen
    }

    package var body: some View {
        TaskbarSessionsCount(
            count: monitor.sessions?.count ?? 0,
            wantsAttention: monitor.reading.wantsAttention
        )
        .padding(SessionsReadoutMetrics.padding)
        .kbTappable(in: shape, perform: onOpen)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: SessionsReadoutMetrics.corner, style: .continuous)
    }
}
