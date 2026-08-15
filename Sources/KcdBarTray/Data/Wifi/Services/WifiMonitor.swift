import Foundation
import Observation

/** The control centre's live view of Wi-Fi. */
@MainActor
@Observable
final class WifiMonitor {
    private(set) var state: WifiState = .unavailable
    private(set) var inRange: [WifiNetwork] = []
    private(set) var nearby: [WifiNetwork] = []
    private(set) var isScanning = false

    private let source: any WifiPort
    private var scannedAt: Date?

    init(source: any WifiPort) {
        self.source = source
    }

    func refresh() {
        state = source.state()
        if inRange.isEmpty {
            inRange = currentOnly
        }
    }

    func setPower(_ isOn: Bool) {
        guard source.setPower(isOn) else { return }

        refresh()
        if !isOn {
            inRange = []
            nearby = []
        }
    }

    func scan(now: Date = Date()) async {
        guard state.isPowered, !isScanning else { return }
        if let scannedAt, now.timeIntervalSince(scannedAt) < WifiMetrics.rescanInterval {
            return
        }
        scannedAt = now
        isScanning = true
        let found = await source.scan()
        inRange = WifiStyle.ordered(found.filter(\.isKnown))
        nearby = WifiStyle.ordered(found.filter { !$0.isKnown })
        isScanning = false

        if inRange.isEmpty {
            inRange = currentOnly
        }
    }

    private var currentOnly: [WifiNetwork] {
        source.knownNetworks().filter(\.isCurrent)
    }
}
