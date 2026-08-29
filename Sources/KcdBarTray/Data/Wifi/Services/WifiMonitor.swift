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

import Foundation
import Observation

/** The control centre's live view of Wi-Fi. */
@MainActor
@Observable
package final class WifiMonitor {
    package private(set) var state: WifiState = .unavailable
    package private(set) var inRange: [WifiNetwork] = []
    package private(set) var nearby: [WifiNetwork] = []
    package private(set) var isScanning = false

    package private(set) var link: NetworkLink = .none
    package private(set) var detail: NetworkDetail?

    private let source: any WifiPort
    private let links: any NetworkLinkPort
    private var scannedAt: Date?

    package init(source: any WifiPort, links: any NetworkLinkPort) {
        self.source = source
        self.links = links
    }

    package func refresh() {
        state = source.state()
        link = links.primaryLink()
        detail = links.detail()
        if inRange.isEmpty {
            inRange = currentOnly
        }
    }

    package func setPower(_ isOn: Bool) {
        guard source.setPower(isOn) else { return }

        refresh()
        if !isOn {
            inRange = []
            nearby = []
        }
    }

    package func scan(now: Date = Date()) async {
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
