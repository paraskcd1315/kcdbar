import KcdBarDesignSystem
import SwiftUI

package struct EthernetTile: View {
    package let name: String
    package let onOpen: () -> Void

    package init(name: String, onOpen: @escaping () -> Void) {
        self.name = name
        self.onOpen = onOpen
    }

    package var body: some View {
        KbTile {
            ConnectivityRow(
                titleKey: "ethernet.title",
                statusKey: LocalizedStringKey(name),
                isOn: true,
                onToggle: onOpen,
                onOpen: onOpen
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
