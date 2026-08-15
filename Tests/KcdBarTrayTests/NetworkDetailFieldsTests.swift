import Testing

@testable import KcdBarTray

struct NetworkDetailFieldsTests {
    private func detail(
        automatic: Bool = true,
        ipv4: String? = "192.168.1.137",
        mask: String? = "255.255.255.0",
        router: String? = "192.168.1.1",
        dns: [String] = ["100.100.1.1", "100.90.1.1"],
        domains: [String] = ["home"],
        ipv6: String? = "2a0c:5a85:7181:d700::1"
    ) -> NetworkDetail {
        NetworkDetail(
            configuresAutomatically: automatic,
            ipv4Address: ipv4,
            subnetMask: mask,
            router: router,
            dnsServers: dns,
            searchDomains: domains,
            ipv6Address: ipv6
        )
    }

    @Test func everySectionMacosShowsIsThere() {
        let rows = NetworkDetailFields.rows(for: detail())

        #expect(rows.map(\.id) == [
            NetworkDetailKeys.method,
            NetworkDetailKeys.address,
            NetworkDetailKeys.subnetMask,
            NetworkDetailKeys.router,
            NetworkDetailKeys.dns,
            NetworkDetailKeys.searchDomains,
            NetworkDetailKeys.ipv6,
        ])
    }

    @Test func severalServersReadAsOneCopyableLine() {
        let rows = NetworkDetailFields.rows(for: detail())
        let dns = rows.first { $0.id == NetworkDetailKeys.dns }

        #expect(dns?.value == "100.100.1.1, 100.90.1.1")
    }

    @Test func whatTheSystemDidNotReportIsOmitted() {
        let rows = NetworkDetailFields.rows(
            for: detail(mask: nil, router: nil, dns: [], domains: [], ipv6: nil)
        )

        #expect(rows.map(\.id) == [NetworkDetailKeys.method, NetworkDetailKeys.address])
    }

    @Test func aManualConfigurationSaysSo() {
        let rows = NetworkDetailFields.rows(for: detail(automatic: false))

        #expect(rows.first?.value == NetworkDetailKeys.manualValue)
    }
}
