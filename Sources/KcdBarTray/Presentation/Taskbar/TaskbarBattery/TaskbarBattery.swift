import KcdBarDesignSystem
import SwiftUI

package struct TaskbarBattery: View {
    package let state: BatteryState
    package let onOpen: () -> Void

    @State private var isHovered = false

    package init(state: BatteryState, onOpen: @escaping () -> Void) {
        self.state = state
        self.onOpen = onOpen
    }

    package var body: some View {
        HStack(spacing: KbSpacing.s1) {
            TaskbarBatteryPill(state: state)
            if let symbol = powerSymbol {
                Image(systemName: symbol)
                    .font(KbTypography.batteryReadout)
                    .foregroundStyle(BatteryTint.colour(for: BatteryStyle.tone(for: state)))
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
        case .charging, .fullyCharged, .pluggedInNotCharging: "bolt.fill"
        case .onBattery: state.isLowPower ? "leaf.fill" : nil
        }
    }

    private var shape: AnyShape {
        AnyShape(RoundedRectangle(cornerRadius: KbRadii.sm))
    }
}
