import SwiftUI

struct BatteryPanelHeader: View {
    let state: BatteryState

    var body: some View {
        VStack(alignment: .leading, spacing: KbSpacing.s1) {
            HStack {
                Text("battery.title")
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.onSurface)
                Spacer(minLength: KbSpacing.s4)
                Text("\(state.percentage)%")
                    .font(KbTypography.panelTitle)
                    .foregroundStyle(KbColors.onSurface)
            }
            Text(sourceKey)
                .font(KbTypography.panelDetail)
                .foregroundStyle(KbColors.onSurfaceMuted)
            Text(statusKey)
                .font(KbTypography.panelDetail)
                .foregroundStyle(KbColors.onSurfaceMuted)
            if let remaining = state.minutesRemaining {
                Text(BatteryFormatting.remaining(minutes: remaining))
                    .font(KbTypography.panelDetail)
                    .foregroundStyle(KbColors.onSurfaceMuted)
            }
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
