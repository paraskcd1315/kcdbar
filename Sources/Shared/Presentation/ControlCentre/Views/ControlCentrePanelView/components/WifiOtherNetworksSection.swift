import SwiftUI

struct WifiOtherNetworksSection: View {
    let monitor: WifiMonitor
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s2) {
            header
            if isExpanded {
                if monitor.isScanning && monitor.nearby.isEmpty {
                    Text("wifi.scanning")
                        .font(KbTypography.tileStatus)
                        .foregroundStyle(KbColors.onSurfaceMuted)
                        .padding(.horizontal, KbSpacing.s4)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(monitor.nearby) { WifiNetworkRow(network: $0) }
                        }
                    }
                    .frame(maxHeight: KbControlCentreMetrics.listMaxHeight)
                    .scrollBounceBehavior(.basedOnSize)
                }
            }
        }
        .animation(KbMotion.standard, value: isExpanded)
        .animation(KbMotion.standard, value: monitor.nearby)
    }

    private var header: some View {
        HStack {
            Text("wifi.section.other")
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
            Spacer(minLength: KbSpacing.s3)
            Image(systemName: WifiMetrics.chevronSymbol)
                .font(KbTypography.tileStatus)
                .foregroundStyle(KbColors.onSurfaceMuted)
                .rotationEffect(.degrees(isExpanded ? 90 : 0))
        }
        .padding(.horizontal, KbSpacing.s4)
        .contentShape(Rectangle())
        .onTapGesture { toggle() }
    }

    private func toggle() {
        isExpanded.toggle()
        guard isExpanded else { return }

        Task { await monitor.scan() }
    }
}
