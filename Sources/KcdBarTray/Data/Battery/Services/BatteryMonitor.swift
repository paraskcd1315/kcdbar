import Foundation
import Observation

/** The bar's live view of the power source. */
@MainActor
@Observable
package final class BatteryMonitor {
    package private(set) var state: BatteryState = .absent
    package private(set) var energyUsers: [EnergyUser] = []
    package private(set) var isSamplingEnergy = false

    private let source: any BatteryPort
    private var sampledAt: Date?

    package var hasSampledEnergy: Bool {
        sampledAt != nil
    }

    package init(source: any BatteryPort) {
        self.source = source
    }

    package func refresh() {
        state = source.state()
    }

    package func sampleEnergy(now: Date = Date()) async {
        if let sampledAt, now.timeIntervalSince(sampledAt) < BatteryMetrics.sampleInterval {
            return
        }
        sampledAt = now
        isSamplingEnergy = true
        energyUsers = BatteryStyle.significant(await source.energyUsers())
        isSamplingEnergy = false
    }
}
