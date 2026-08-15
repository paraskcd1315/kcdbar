import SwiftUI

struct WifiDetail: View {
    let monitor: WifiMonitor

    @State private var showsKnown = false
    @State private var showsOther = false

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s2) {
            HStack {
                Text("wifi.title")
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.onSurface)
                Spacer(minLength: KbSpacing.s5)
                WifiToggle(isOn: monitor.state.isPowered) { monitor.setPower($0) }
            }
            .padding(.horizontal, KbSpacing.s4)

            if monitor.state.isPowered {
                sections
            }
        }
    }

    private var sections: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                Section {
                    if showsKnown {
                        ForEach(monitor.known) { WifiNetworkRow(network: $0) }
                    }
                } header: {
                    WifiSectionHeader(
                        titleKey: "wifi.section.known",
                        count: monitor.known.count,
                        isExpanded: showsKnown
                    ) {
                        withAnimation(KbMotion.standard) { showsKnown.toggle() }
                    }
                }
                Section {
                    if showsOther {
                        WifiNearbyList(monitor: monitor)
                    }
                } header: {
                    WifiSectionHeader(
                        titleKey: "wifi.section.other",
                        count: monitor.nearby.count,
                        isExpanded: showsOther
                    ) {
                        withAnimation(KbMotion.standard) { showsOther.toggle() }
                        guard showsOther else { return }

                        Task { await monitor.scan() }
                    }
                }
            }
        }
        .frame(maxHeight: KbControlCentreMetrics.listMaxHeight)
        .scrollBounceBehavior(.basedOnSize)
    }
}
