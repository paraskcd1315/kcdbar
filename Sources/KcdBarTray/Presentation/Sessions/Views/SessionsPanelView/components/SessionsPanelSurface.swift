import KcdBarDesignSystem
import SwiftUI

package struct SessionsPanelSurface: View {
    package let sessions: [ClaudeSession]
    package let arrowX: CGFloat
    package let onFocus: (ClaudeSession) -> Void

    package init(
        sessions: [ClaudeSession],
        arrowX: CGFloat,
        onFocus: @escaping (ClaudeSession) -> Void
    ) {
        self.sessions = sessions
        self.arrowX = arrowX
        self.onFocus = onFocus
    }

    package var body: some View {
        TimelineView(.periodic(from: .now, by: SessionsPanelMetrics.tick)) { context in
            VStack(alignment: .leading, spacing: KbSpacing.s5) {
                SessionsPanelHeader(count: sessions.count)
                Rectangle()
                    .fill(KbColors.separator)
                    .frame(height: KbPopoverMetrics.dividerHeight)

                if sessions.isEmpty {
                    Text("sessions.none")
                        .font(KbTypography.panelDetail)
                        .foregroundStyle(KbColors.onSurfaceMuted)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, KbSpacing.s6)
                } else {
                    SessionsPanelList(
                        sessions: sessions, now: context.date, onFocus: onFocus)
                }
            }
            .padding(.horizontal, KbSpacing.s6)
            .padding(.top, KbSpacing.s6)
            .padding(.bottom, KbSpacing.s6 + KbPopoverMetrics.arrowSize.height)
        }
        .frame(width: SessionsReadoutMetrics.panelWidth, alignment: .leading)
        .glassEffect(.regular.interactive(), in: KbPopoverShape(arrowX: arrowX))
        .overlay { KbPopoverEdge(arrowX: arrowX) }
    }
}
