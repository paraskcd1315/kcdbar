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
                known
                WifiDisclosureRow(titleKey: "wifi.section.other", isExpanded: showsOther) {
                    withAnimation(KbMotion.standard) { showsOther.toggle() }
                    guard showsOther else { return }

                    Task { await monitor.scan() }
                }
                if showsOther {
                    other
                }
            }
            WifiSettingsRow(onOpen: onOpenSettings)
        }
        .task { await monitor.scan() }
    }

    @ViewBuilder
    private var known: some View {
        if !monitor.inRange.isEmpty {
            Text("wifi.section.known")
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .padding(.horizontal, KbSpacing.s4)
            ForEach(monitor.inRange) { WifiNetworkRow(network: $0) }
        }
    }

    private var other: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                WifiNearbyList(monitor: monitor)
            }
        }
        .frame(
            height: WifiMetrics.listHeight(
                rows: max(monitor.nearby.count, 1),
                cap: KbControlCentreMetrics.listMaxHeight
            )
        )
        .scrollBounceBehavior(.basedOnSize)
    }
}
