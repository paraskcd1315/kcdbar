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

/** The rows the network pane shows, in macOS's own order, omitting what the system did not report. */
package enum NetworkDetailFields {
    package static func rows(for detail: NetworkDetail) -> [NetworkDetailField] {
        var rows: [NetworkDetailField] = [
            NetworkDetailField(
                id: NetworkDetailKeys.method,
                titleKey: NetworkDetailKeys.method,
                value: detail.configuresAutomatically
                    ? NetworkDetailKeys.dhcpValue
                    : NetworkDetailKeys.manualValue
            )
        ]
        append(&rows, NetworkDetailKeys.address, detail.ipv4Address)
        append(&rows, NetworkDetailKeys.subnetMask, detail.subnetMask)
        append(&rows, NetworkDetailKeys.router, detail.router)
        append(&rows, NetworkDetailKeys.dns, joined(detail.dnsServers))
        append(&rows, NetworkDetailKeys.searchDomains, joined(detail.searchDomains))
        append(&rows, NetworkDetailKeys.ipv6, detail.ipv6Address)

        return rows
    }

    private static func append(_ rows: inout [NetworkDetailField], _ key: String, _ value: String?) {
        guard let value, !value.isEmpty else { return }

        rows.append(NetworkDetailField(id: key, titleKey: key, value: value))
    }

    private static func joined(_ values: [String]) -> String? {
        values.isEmpty ? nil : values.joined(separator: NetworkDetailKeys.separator)
    }
}
