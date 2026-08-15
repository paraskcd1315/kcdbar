import KcdBarDesignSystem
import SwiftUI

package struct EthernetTile: View {
    package let name: String
    package let onOpenSettings: () -> Void

    package init(name: String, onOpenSettings: @escaping () -> Void) {
        self.name = name
        self.onOpenSettings = onOpenSettings
    }

    package var body: some View {
        KbTile {
            ConnectivityRow(
                titleKey: "ethernet.title",
                statusKey: LocalizedStringKey(name),
                isOn: true,
                onToggle: onOpenSettings,
                onOpen: onOpenSettings
            ) {
                Image(systemName: NetworkLinkKeys.ethernetSymbol)
                    .font(
                        .system(
                            size: KbControlCentreMetrics.rowGlyphSize
                                * KbControlCentreMetrics.glyphRatio
                        )
                    )
            }
        }
    }
}
