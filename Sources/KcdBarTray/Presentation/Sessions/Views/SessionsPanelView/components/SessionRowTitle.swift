import KcdBarDesignSystem
import SwiftUI

package struct SessionRowTitle: View {
    package let session: ClaudeSession

    package init(session: ClaudeSession) {
        self.session = session
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s2) {
            Text(session.title)
                .font(KbTypography.panelItem)
                .foregroundStyle(KbColors.onSurface)
                .lineLimit(1)
                .truncationMode(.middle)

            if session.isTerminal {
                Text("sessions.terminal")
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }

            if let project = session.project {
                Text(project)
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
    }
}
