import SwiftUI

/** Builds the sessions popover's content, so no AppKit host constructs a view. */
@MainActor
package enum SessionsPanelPresentation {
    package static func content(
        monitor: SessionsMonitor,
        presentation: PopoverPresentation,
        arrowX: CGFloat
    ) -> AnyView {
        AnyView(
            SessionsPanelView(
                sessions: monitor.sessions ?? [],
                arrowX: arrowX,
                presentation: presentation,
                onFocus: { monitor.focus($0) }
            )
        )
    }
}
