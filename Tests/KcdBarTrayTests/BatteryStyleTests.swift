import Testing
@testable import KcdBarTray

struct BatteryStyleTests {
    private func state(
        percentage: Int,
        charging: Bool = false,
        charged: Bool = false,
        plugged: Bool = false,
        lowPower: Bool = false
    ) -> BatteryState {
        BatteryState(
            isPresent: true,
            percentage: percentage,
            isCharging: charging,
            isCharged: charged,
            isPluggedIn: plugged,
            isLowPower: lowPower,
            minutesRemaining: nil
        )
    }

    @Test func aHealthyBatteryOnItsOwnPowerReadsNeutral() {
        #expect(BatteryStyle.tone(for: state(percentage: 80)) == .neutral)
        #expect(BatteryStyle.tone(for: state(percentage: 80, plugged: true)) == .neutral)
    }

    @Test func greenIsForChargingAndForACompletedCharge() {
        #expect(BatteryStyle.tone(for: state(percentage: 80, charging: true, plugged: true)) == .full)
        #expect(BatteryStyle.tone(for: state(percentage: 100, charged: true, plugged: true)) == .full)
    }

    @Test func itWarnsBeforeItGoesCritical() {
        #expect(BatteryStyle.tone(for: state(percentage: 25)) == .warning)
        #expect(BatteryStyle.tone(for: state(percentage: 11)) == .warning)
    }

    @Test func aNearlyEmptyBatteryReadsCritical() {
        #expect(BatteryStyle.tone(for: state(percentage: 10)) == .critical)
        #expect(BatteryStyle.tone(for: state(percentage: 5)) == .critical)
    }

    @Test func lowPowerModeOverridesEveryOtherTone() {
        #expect(BatteryStyle.tone(for: state(percentage: 5, lowPower: true)) == .powerSave)
        #expect(BatteryStyle.tone(for: state(percentage: 90, lowPower: true)) == .powerSave)
    }

    @Test func aLowChargeStaysCriticalWhileItCharges() {
        #expect(BatteryStyle.tone(for: state(percentage: 4, charging: true, plugged: true)) == .critical)
    }

    @Test func pluggedInWithoutChargingIsItsOwnStatus() {
        #expect(BatteryStyle.status(for: state(percentage: 80, plugged: true)) == .pluggedInNotCharging)
        #expect(BatteryStyle.status(for: state(percentage: 100, charged: true, plugged: true)) == .fullyCharged)
        #expect(BatteryStyle.status(for: state(percentage: 50, charging: true, plugged: true)) == .charging)
        #expect(BatteryStyle.status(for: state(percentage: 50)) == .onBattery)
    }

    @Test func theFillNeverCollapsesToNothing() {
        #expect(BatteryStyle.fill(for: state(percentage: 0)) > 0)
        #expect(BatteryStyle.fill(for: state(percentage: 100)) == 1)
    }

    @Test func onlyApplicationsOverTheThresholdCountAsSignificant() {
        let users = [
            EnergyUser(name: "Google Chrome", impact: 45),
            EnergyUser(name: "Quiet", impact: 3),
            EnergyUser(name: "Xcode", impact: 22)
        ]

        #expect(BatteryStyle.significant(users).map(\.name) == ["Google Chrome", "Xcode"])
    }

    @Test func remainingTimeReadsAsHoursAndMinutes() {
        #expect(BatteryFormatting.remaining(minutes: 45) == "45 min")
        #expect(BatteryFormatting.remaining(minutes: 135) == "2 h 15 min")
    }
}
