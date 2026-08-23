import KcdBarDesignSystem
import SwiftUI

package struct SessionRowLine: View {
    package let session: ClaudeSession
    package let now: Date

    package init(session: ClaudeSession, now: Date) {
        self.session = session
        self.now = now
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s2) {
            if session.isBlocked {
                Text("sessions.waitingOnYou")
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.batteryWarning)

                if let reason = session.waitingFor, !reason.isEmpty {
                    Text(reason)
                        .font(KbTypography.trackingLabel)
                        .foregroundStyle(KbColors.onSurfaceMuted)
                        .lineLimit(1)
                }
            } else {
                Text(doing)
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(KbColors.onSurfaceMuted)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            if let context = session.context {
                Text(SessionsFormatting.share(context))
                    .font(KbTypography.trackingLabel)
                    .foregroundStyle(context.isTight ? KbColors.batteryWarning : KbColors.onSurfaceMuted)
                    .monospacedDigit()
            }
        }
    }

    private var doing: String {
        if let doing = session.doing, !doing.isEmpty { return doing }

        guard let quiet = session.quietFor(at: now) else { return standing }

        return "\(standing) · \(SessionsFormatting.quiet(quiet))"
    }

    private var standing: String {
        guard let standing = session.standing else { return "" }

        return SessionsCopy.standing(standing)
    }
}
