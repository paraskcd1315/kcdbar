import SwiftUI

struct WifiDetail: View {
    let monitor: WifiMonitor
    let onOpenSettings: () -> Void

    @State private var showsOther = false

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            HStack {
                Text("wifi.title")
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.onSurface)
                Spacer(minLength: KbSpacing.s5)
                WifiToggle(isOn: monitor.state.isPowered) { monitor.setPower($0) }
            }
            .padding(.horizontal, KbSpacing.s4)

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
