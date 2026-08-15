package struct NetworkDetail: Equatable {
    package let configuresAutomatically: Bool
    package let ipv4Address: String?
    package let subnetMask: String?
    package let router: String?
    package let dnsServers: [String]
    package let searchDomains: [String]
    package let ipv6Address: String?

    package init(
        configuresAutomatically: Bool,
        ipv4Address: String?,
        subnetMask: String?,
        router: String?,
        dnsServers: [String],
        searchDomains: [String],
        ipv6Address: String?
    ) {
        self.configuresAutomatically = configuresAutomatically
        self.ipv4Address = ipv4Address
        self.subnetMask = subnetMask
        self.router = router
        self.dnsServers = dnsServers
        self.searchDomains = searchDomains
        self.ipv6Address = ipv6Address
    }
}
