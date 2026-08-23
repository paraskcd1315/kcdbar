import KcdBarDesignSystem
import SwiftUI

package struct SessionsPanelView: View {
    package let sessions: [ClaudeSession]
    package let arrowX: CGFloat
    package let presentation: PopoverPresentation
    package let onFocus: (ClaudeSession) -> Void

    package init(
        sessions: [ClaudeSession],
        arrowX: CGFloat,
        presentation: PopoverPresentation,
        onFocus: @escaping (ClaudeSession) -> Void
    ) {
        self.sessions = sessions
        self.arrowX = arrowX
        self.presentation = presentation
        self.onFocus = onFocus
    }

    package var body: some View {
        GlassEffectContainer {
            SessionsPanelSurface(sessions: sessions, arrowX: arrowX, onFocus: onFocus)
        }
        .scaleEffect(
            x: 1,
            y: presentation.isExpanded ? 1 : KbPopoverMetrics.collapsedScale,
            anchor: .bottom
        )
        .opacity(presentation.isExpanded ? 1 : 0)
    }
}
