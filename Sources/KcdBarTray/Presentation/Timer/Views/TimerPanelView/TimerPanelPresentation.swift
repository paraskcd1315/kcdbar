import SwiftUI

/** Builds the timer popover's content, so no AppKit host constructs a view. */
@MainActor
package enum TimerPanelPresentation {
    package static func content(
        monitor: TimerMonitor,
        presentation: PopoverPresentation,
        arrowX: CGFloat
    ) -> AnyView {
        AnyView(
            TimerPanelView(
                timers: monitor.reading.timers,
                arrowX: arrowX,
                presentation: presentation
            )
        )
    }
}
