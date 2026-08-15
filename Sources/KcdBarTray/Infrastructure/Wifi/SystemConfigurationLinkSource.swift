import CoreWLAN
import Foundation
import SystemConfiguration

/** Which interface carries the default route, and what the system reports about it. */
@MainActor
package struct SystemConfigurationLinkSource: NetworkLinkPort {
    package init() {}

    package func primaryLink() -> NetworkLink {
        guard let primary = global()?[NetworkLinkKeys.primaryInterface] as? String else {
            return .none
        }
        guard primary != CWWiFiClient.shared().interface()?.interfaceName else { return .wifi }

        return .ethernet(name: displayName(of: primary) ?? primary)
    }

    package func detail() -> NetworkDetail? {
        guard let service = global()?[NetworkLinkKeys.primaryService] as? String else { return nil }

        let ipv4 = value(atState: service, suffix: NetworkLinkKeys.ipv4Suffix)
        let ipv6 = value(atState: service, suffix: NetworkLinkKeys.ipv6Suffix)
        let dns = value(atState: service, suffix: NetworkLinkKeys.dnsSuffix)
        let setup = value(atSetup: service, suffix: NetworkLinkKeys.ipv4Suffix)

        return NetworkDetail(
            configuresAutomatically: setup?[NetworkLinkKeys.configMethod] as? String
                == NetworkLinkKeys.dhcpMethod,
            ipv4Address: first(ipv4, NetworkLinkKeys.addresses),
            subnetMask: first(ipv4, NetworkLinkKeys.subnetMasks),
            router: ipv4?[NetworkLinkKeys.router] as? String,
            dnsServers: list(dns, NetworkLinkKeys.serverAddresses),
            searchDomains: list(dns, NetworkLinkKeys.searchDomains),
            ipv6Address: first(ipv6, NetworkLinkKeys.addresses)
        )
    }

    private func global() -> [String: Any]? {
        guard let store = store() else { return nil }

        return SCDynamicStoreCopyValue(store, NetworkLinkKeys.globalIpv4 as CFString)
            as? [String: Any]
    }

    private func value(atState service: String, suffix: String) -> [String: Any]? {
        copy(key: NetworkLinkKeys.servicePrefix + service + suffix)
    }

    private func value(atSetup service: String, suffix: String) -> [String: Any]? {
        copy(key: NetworkLinkKeys.setupPrefix + service + suffix)
    }

    private func copy(key: String) -> [String: Any]? {
        guard let store = store() else { return nil }

        return SCDynamicStoreCopyValue(store, key as CFString) as? [String: Any]
    }

    private func store() -> SCDynamicStore? {
        SCDynamicStoreCreate(nil, NetworkLinkKeys.storeName as CFString, nil, nil)
    }

    private func first(_ dictionary: [String: Any]?, _ key: String) -> String? {
        list(dictionary, key).first
    }

    private func list(_ dictionary: [String: Any]?, _ key: String) -> [String] {
        dictionary?[key] as? [String] ?? []
    }

    private func displayName(of bsdName: String) -> String? {
        guard let interfaces = SCNetworkInterfaceCopyAll() as? [SCNetworkInterface] else {
            return nil
        }
        let match = interfaces.first { SCNetworkInterfaceGetBSDName($0) as String? == bsdName }

        return match.flatMap { SCNetworkInterfaceGetLocalizedDisplayName($0) as String? }
    }
}
