import KcdBarDesignSystem
import SwiftUI

package struct WifiDetail: View {
    package let monitor: WifiMonitor
    package let onBack: () -> Void
    package let onOpenSettings: () -> Void

    @State private var showsOther = false

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            WifiDetailHeader(
                isPowered: monitor.state.isPowered,
                onBack: onBack,
                onSetPower: { monitor.setPower($0) }
            )
            if monitor.state.isPowered {
                WifiKnownList(networks: monitor.inRange)
                WifiDisclosureRow(titleKey: "wifi.section.other", isExpanded: showsOther) {
                    withAnimation(KbMotion.standard) { showsOther.toggle() }
                    guard showsOther else { return }

                    Task { await monitor.scan() }
                }
                if showsOther {
                    WifiOtherList(monitor: monitor)
                }
            }
            WifiSettingsRow(onOpen: onOpenSettings)
        }
        .task { await monitor.scan() }
    }
}
