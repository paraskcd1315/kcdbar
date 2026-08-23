import KcdBarDesignSystem
import SwiftUI

package struct SessionRowDot: View {
    package let session: ClaudeSession

    package init(session: ClaudeSession) {
        self.session = session
    }

    package var body: some View {
        Circle()
            .fill(tone)
            .frame(
                width: SessionsReadoutMetrics.dotSide,
                height: SessionsReadoutMetrics.dotSide)
    }

    private var tone: Color {
        if session.isBlocked { return KbColors.batteryWarning }

        if session.isWorking { return KbColors.batteryFull }

        return KbColors.onSurfaceMuted
    }
}
