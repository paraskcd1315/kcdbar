// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
