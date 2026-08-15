import SwiftUI

/** Builds the battery popover's content, so no AppKit host constructs a view. */
@MainActor
package enum BatteryPanelPresentation {
    package static func content(
        monitor: BatteryMonitor,
        presentation: PopoverPresentation,
        arrowX: CGFloat
    ) -> AnyView {
        AnyView(
            BatteryPanelView(
                state: monitor.state,
                energyUsers: monitor.energyUsers,
                isSampling: monitor.isSamplingEnergy,
                arrowX: arrowX,
                presentation: presentation
            )
        )
    }
}
