import SwiftUI

/** Builds the control centre's content, so no AppKit host constructs a view. */
@MainActor
package enum ControlCentrePresentation {
    package static func content(
        wifi: WifiMonitor,
        bluetooth: BluetoothMonitor,
        sound: SoundMonitor,
        brightness: BrightnessMonitor,
        presentation: PopoverPresentation,
        onOpenSettings: @escaping () -> Void
    ) -> AnyView {
        AnyView(
            ControlCentrePanelView(
                wifi: wifi,
                bluetooth: bluetooth,
                sound: sound,
                brightness: brightness,
                presentation: presentation,
                onOpenSettings: onOpenSettings
            )
        )
    }
}
