import KcdBarDesignSystem
import KcdBarTray
import SwiftUI

/** The working rim, in a view graph of its own so its clock never reaches the bar's. */
package struct TaskbarRimLayer: View {
    package let presetState: BarPresetState
    package let frame: BarFrameState
    package let sessions: SessionsMonitor

    package init(presetState: BarPresetState, frame: BarFrameState, sessions: SessionsMonitor) {
        self.presetState = presetState
        self.frame = frame
        self.sessions = sessions
    }

    package var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear

            if let rect = TaskbarRimPlacement.rect(
                measured: frame.frame, attachment: presetState.preset.attachment)
            {
                Color.clear
                    .frame(width: rect.width, height: rect.height)
                    .kbWorkingStreaks(
                        sessions.reading.isWorking,
                        isLoud: sessions.reading.wantsAttention,
                        corner: presetState.preset.cornerRadius,
                        rimWidth: KbStreakMetrics.barRimWidth,
                        rimBlur: KbStreakMetrics.barRimBlur
                    )
                    .offset(x: rect.minX, y: rect.minY)
            }
        }
        .allowsHitTesting(false)
    }
}
