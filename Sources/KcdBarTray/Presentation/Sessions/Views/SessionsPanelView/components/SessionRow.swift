import KcdBarDesignSystem
import SwiftUI

package struct SessionRow: View {
    package let session: ClaudeSession
    package let now: Date
    package let onFocus: (ClaudeSession) -> Void

    @State private var isHovering = false

    package init(
        session: ClaudeSession,
        now: Date,
        onFocus: @escaping (ClaudeSession) -> Void
    ) {
        self.session = session
        self.now = now
        self.onFocus = onFocus
    }

    package var body: some View {
        HStack(alignment: .top, spacing: KbSpacing.s4) {
            SessionRowDot(session: session)
                .padding(.top, KbSpacing.s2)

            VStack(alignment: .leading, spacing: KbSpacing.s1) {
                SessionRowTitle(session: session)
                SessionRowLine(session: session, now: now)
            }
        }
        .padding(.vertical, KbSpacing.s2)
        .padding(.horizontal, KbSpacing.s3)
        .background(background, in: shape)
        .kbTappable(in: shape, perform: focus)
        .onHover { isHovering = $0 }
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: KbRadii.sm, style: .continuous)
    }

    private var background: Color {
        isHovering && session.hasPane ? KbColors.separator : .clear
    }

    private func focus() {
        guard session.hasPane else { return }

        onFocus(session)
    }
}
