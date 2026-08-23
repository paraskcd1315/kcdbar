import SwiftUI

/** Builds the day popover's content, so no AppKit host constructs a view. */
@MainActor
package enum DayPanelPresentation {
    package static func content(
        monitor: DayMonitor,
        presentation: PopoverPresentation,
        arrowX: CGFloat
    ) -> AnyView {
        AnyView(
            DayPanelView(
                day: monitor.day,
                arrowX: arrowX,
                presentation: presentation,
                onOpen: { monitor.open($0) }
            )
        )
    }
}
