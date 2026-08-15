import SwiftUI

/** Builds the battery popover's content, so no AppKit host constructs a view. */
@MainActor
enum BatteryPanelPresentation {
    static func content(
        state: BatteryState,
        energyUsers: [EnergyUser],
        presentation: PopoverPresentation,
        arrowX: CGFloat
    ) -> AnyView {
        AnyView(
            BatteryPanelView(
                state: state,
                energyUsers: energyUsers,
                arrowX: arrowX,
                presentation: presentation
            )
        )
    }
}
