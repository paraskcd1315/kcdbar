import Foundation
import Observation

/** The control centre's live view of Wi-Fi. */
@MainActor
@Observable
final class WifiMonitor {
    private(set) var state: WifiState = .unavailable
    private(set) var known: [WifiNetwork] = []
    private(set) var nearby: [WifiNetwork] = []
    private(set) var isScanning = false

    private let source: any WifiPort

    init(source: any WifiPort) {
        self.source = source
    }

    func refresh() {
        state = source.state()
        known = WifiStyle.ordered(source.knownNetworks())
    }

    func setPower(_ isOn: Bool) {
        guard source.setPower(isOn) else { return }

        refresh()
        if !isOn {
            nearby = []
        }
    }

    func scan() async {
        guard state.isPowered, !isScanning else { return }

        isScanning = true
        let found = await source.scan()
        nearby = WifiStyle.ordered(found.filter { !$0.isKnown })
        isScanning = false
    }
}
