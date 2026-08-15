import SwiftUI

struct BatteryPanelHeader: View {
    let state: BatteryState

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s3) {
            HStack {
                Text("battery.title")
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.onSurface)
                Spacer(minLength: KbSpacing.s5)
                Text("\(state.percentage)%")
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.battery(BatteryStyle.tone(for: state)))
            }
            VStack(alignment: .leading, spacing: KbSpacing.s2) {
                Text(sourceKey)
                Text(statusKey)
                if let remaining = state.minutesRemaining {
                    Text(BatteryFormatting.remaining(minutes: remaining))
                }
            }
            .font(KbTypography.panelDetail)
            .foregroundStyle(KbColors.onSurfaceMuted)
        }
    }

    private var sourceKey: LocalizedStringKey {
        state.isPluggedIn ? "battery.source.adapter" : "battery.source.battery"
    }

    private var statusKey: LocalizedStringKey {
        switch BatteryStyle.status(for: state) {
        case .fullyCharged: "battery.status.charged"
        case .charging: "battery.status.charging"
        case .pluggedInNotCharging: "battery.status.notCharging"
        case .onBattery: state.isLowPower ? "battery.status.lowPower" : "battery.status.discharging"
        }
    }
}
