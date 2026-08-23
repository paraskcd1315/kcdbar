import KcdBarDesignSystem
import SwiftUI

package struct SessionsPanelList: View {
    package let sessions: [ClaudeSession]
    package let now: Date
    package let onFocus: (ClaudeSession) -> Void

    package init(
        sessions: [ClaudeSession],
        now: Date,
        onFocus: @escaping (ClaudeSession) -> Void
    ) {
        self.sessions = sessions
        self.now = now
        self.onFocus = onFocus
    }

    package var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: SessionsReadoutMetrics.rowSpacing) {
                ForEach(sessions) { session in
                    SessionRow(session: session, now: now, onFocus: onFocus)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxHeight: SessionsReadoutMetrics.listMaxHeight)
    }
}
