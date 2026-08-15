import Foundation
import Observation

/** The bar's live view of the power source. */
@MainActor
@Observable
final class BatteryMonitor {
    private(set) var state: BatteryState = .absent
    private(set) var energyUsers: [EnergyUser] = []

    private let source: any BatteryPort
    private var sampledAt: Date?

    init(source: any BatteryPort) {
        self.source = source
    }

    func refresh() {
        state = source.state()
    }

    func sampleEnergy(now: Date = Date()) async {
        if let sampledAt, now.timeIntervalSince(sampledAt) < BatteryMetrics.sampleInterval {
            return
        }
        sampledAt = now
        energyUsers = BatteryStyle.significant(await source.energyUsers())
    }
}
