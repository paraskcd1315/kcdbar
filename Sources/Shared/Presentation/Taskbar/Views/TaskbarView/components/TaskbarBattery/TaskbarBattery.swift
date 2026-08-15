import SwiftUI

struct TaskbarBattery: View {
    let state: BatteryState
    let onOpen: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: KbSpacing.s1) {
            TaskbarBatteryPill(state: state)
            if let symbol = powerSymbol {
                Image(systemName: symbol)
                    .font(KbTypography.batteryReadout)
                    .foregroundStyle(KbColors.battery(BatteryStyle.tone(for: state)))
            }
        }
        .padding(.horizontal, KbSpacing.s2)
        .padding(.vertical, KbSpacing.s1)
        .contentShape(shape)
        .onTapGesture(perform: onOpen)
        .glassEffect(isHovered ? .regular.interactive() : .identity, in: shape)
        .animation(KbMotion.quick, value: isHovered)
        .onHover { isHovered = $0 }
    }

    private var powerSymbol: String? {
        switch BatteryStyle.status(for: state) {
        case .charging: "bolt.fill"
        case .fullyCharged, .pluggedInNotCharging: "powerplug.fill"
        case .onBattery: state.isLowPower ? "leaf.fill" : nil
        }
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
