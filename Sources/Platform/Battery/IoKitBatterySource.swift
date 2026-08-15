import Foundation
import IOKit.ps

struct IoKitBatterySource: BatteryPort {
    func state() -> BatteryState {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
              let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef]
        else {
            return .absent
        }

        for source in sources {
            guard let description = IOPSGetPowerSourceDescription(snapshot, source)?
                .takeUnretainedValue() as? [String: Any],
                description[kIOPSIsPresentKey] as? Bool == true,
                let capacity = description[kIOPSCurrentCapacityKey] as? Int,
                let maximum = description[kIOPSMaxCapacityKey] as? Int,
                maximum > 0
            else {
                continue
            }

            let isCharging = description[kIOPSIsChargingKey] as? Bool ?? false
            let onAdapter = description[kIOPSPowerSourceStateKey] as? String == kIOPSACPowerValue

            return BatteryState(
                isPresent: true,
                percentage: Int((Double(capacity) / Double(maximum) * 100).rounded()),
                isCharging: isCharging,
                isCharged: description[kIOPSIsChargedKey] as? Bool ?? false,
                isPluggedIn: onAdapter,
                isLowPower: ProcessInfo.processInfo.isLowPowerModeEnabled,
                minutesRemaining: remaining(from: description, isCharging: isCharging)
            )
        }

        return .absent
    }

    func energyUsers() async -> [EnergyUser] {
        await TopEnergySampler.sample()
    }

    private func remaining(from description: [String: Any], isCharging: Bool) -> Int? {
        let key = isCharging ? kIOPSTimeToFullChargeKey : kIOPSTimeToEmptyKey
        guard let minutes = description[key] as? Int, minutes > 0 else { return nil }

        return minutes
    }
}
