import KcdBarDesignSystem
import SwiftUI

package struct WifiDetail: View {
    package let monitor: WifiMonitor
    package let onBack: () -> Void
    package let onCopy: (String) -> Void
    package let onOpenSettings: () -> Void

    @State private var showsOther = false

    package var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            ControlCentreDetailHeader(
                titleKey: "wifi.title",
                isOn: monitor.state.isPowered,
                onBack: onBack,
                onSetPower: { monitor.setPower($0) }
            )
            ControlCentreDetailBody {
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
                    if let detail = monitor.detail {
                        ControlCentreAccordion(titleKey: "network.details") {
                            NetworkDetailList(detail: detail, onCopy: onCopy)
                        }
                    }
                }
            }
            ControlCentreSettingsRow(titleKey: "wifi.settings", onOpen: onOpenSettings)
        }
        .task { await monitor.scan() }
    }
}
