import CoreWLAN
import Foundation
import SystemConfiguration

/** Which interface currently carries the default route. */
@MainActor
package struct SystemConfigurationLinkSource: NetworkLinkPort {
    package init() {}

    package func primaryLink() -> NetworkLink {
        guard let store = SCDynamicStoreCreate(nil, NetworkLinkKeys.storeName as CFString, nil, nil),
              let global = SCDynamicStoreCopyValue(store, NetworkLinkKeys.globalIpv4 as CFString)
                as? [String: Any],
              let primary = global[NetworkLinkKeys.primaryInterface] as? String
        else {
            return .none
        }
        guard primary != CWWiFiClient.shared().interface()?.interfaceName else { return .wifi }

        return .ethernet(name: displayName(of: primary) ?? primary)
    }

    private func displayName(of bsdName: String) -> String? {
        guard let interfaces = SCNetworkInterfaceCopyAll() as? [SCNetworkInterface] else {
            return nil
        }
        let match = interfaces.first { SCNetworkInterfaceGetBSDName($0) as String? == bsdName }

        return match.flatMap { SCNetworkInterfaceGetLocalizedDisplayName($0) as String? }
    }
}
