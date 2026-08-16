import KcdBarDesignSystem
import SwiftUI

package struct TimerPanelList: View {
    package let timers: [RunningTimer]
    package let now: Date
    package let onOpen: (RunningTimer) -> Void

    package var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TimerReadoutMetrics.rowSpacing) {
                ForEach(Array(timers.enumerated()), id: \.offset) { _, timer in
                    TimerPanelRow(timer: timer, now: now, onOpen: { onOpen(timer) })
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxHeight: TimerReadoutMetrics.listMaxHeight)
        .scrollBounceBehavior(.basedOnSize)
    }
}
