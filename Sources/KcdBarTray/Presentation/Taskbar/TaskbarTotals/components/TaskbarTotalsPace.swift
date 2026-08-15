import KcdBarDesignSystem
import SwiftUI

package struct TaskbarTotalsPace: View {
    package let pace: TrackerPace

    package var body: some View {
        if pace.isOver {
            TaskbarTotalsFigure(
                label: "totals.overBy",
                seconds: pace.overSeconds,
                tone: KbColors.batteryCritical
            )
        } else {
            TaskbarTotalsFigure(
                label: "totals.left",
                seconds: pace.remainingSeconds,
                tone: pace.remainingSeconds > 0 ? KbColors.brand : KbColors.batteryFull
            )
        }
    }
}
