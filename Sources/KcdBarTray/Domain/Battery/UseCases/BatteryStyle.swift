import CoreGraphics

package enum BatteryStyle {
    package static func tone(for state: BatteryState) -> BatteryTone {
        if state.isLowPower { return .powerSave }
        if state.isCharging || state.isCharged { return .full }
        if state.percentage <= BatteryMetrics.criticalPercentage { return .critical }
        if state.percentage <= BatteryMetrics.warningPercentage { return .warning }

        return .full
    }

    package static func status(for state: BatteryState) -> BatteryStatus {
        if state.isCharged { return .fullyCharged }
        if state.isCharging { return .charging }
        if state.isPluggedIn { return .pluggedInNotCharging }

        return .onBattery
    }

    package static func fill(for state: BatteryState) -> CGFloat {
        let fraction = CGFloat(state.percentage) / CGFloat(BatteryMetrics.fullPercentage)

        return max(BatteryMetrics.minimumFill, min(1, fraction))
    }

    package static func significant(_ users: [EnergyUser]) -> [EnergyUser] {
        users
            .filter { $0.impact >= BatteryMetrics.significantEnergyImpact }
            .sorted { $0.impact > $1.impact }
            .prefix(BatteryMetrics.significantEnergyLimit)
            .map { $0 }
    }
}
