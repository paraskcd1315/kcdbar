import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTimer: View {
    package let monitor: TimerMonitor

    package init(monitor: TimerMonitor) {
        self.monitor = monitor
    }

    package var body: some View {
        let running = monitor.reading.timers

        if !running.isEmpty {
            TaskbarTimerReadout(timers: running, only: monitor.reading.only)
        }
    }
}
