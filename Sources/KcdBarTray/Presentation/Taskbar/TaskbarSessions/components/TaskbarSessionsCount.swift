import KcdBarDesignSystem
import SwiftUI

package struct TaskbarSessionsCount: View {
    package let count: Int
    package let wantsAttention: Bool

    package init(count: Int, wantsAttention: Bool) {
        self.count = count
        self.wantsAttention = wantsAttention
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s2) {
            Image(systemName: symbol)
                .font(.system(size: SessionsReadoutMetrics.glyphSide))
                .foregroundStyle(tone)

            Text(verbatim: "\(count)")
                .font(KbTypography.clockTime)
                .foregroundStyle(KbColors.onSurface)
                .monospacedDigit()
        }
        .fixedSize(horizontal: true, vertical: false)
    }

    private var symbol: String {
        wantsAttention
            ? SessionsReadoutMetrics.waitingSymbol : SessionsReadoutMetrics.glyphSymbol
    }

    private var tone: Color {
        wantsAttention ? KbColors.batteryWarning : KbColors.brand
    }
}
