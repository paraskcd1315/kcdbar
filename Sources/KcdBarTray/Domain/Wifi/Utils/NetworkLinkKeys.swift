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

package enum NetworkLinkKeys {
    package static let storeName = "com.paraskcd.kcdbar.network"
    package static let globalIpv4 = "State:/Network/Global/IPv4"
    package static let primaryInterface = "PrimaryInterface"

    package static let ethernetSymbol = "cable.connector"

    package static let primaryService = "PrimaryService"
    package static let servicePrefix = "State:/Network/Service/"
    package static let setupPrefix = "Setup:/Network/Service/"
    package static let ipv4Suffix = "/IPv4"
    package static let ipv6Suffix = "/IPv6"
    package static let dnsSuffix = "/DNS"

    package static let addresses = "Addresses"
    package static let subnetMasks = "SubnetMasks"
    package static let router = "Router"
    package static let serverAddresses = "ServerAddresses"
    package static let searchDomains = "SearchDomains"
    package static let configMethod = "ConfigMethod"
    package static let dhcpMethod = "DHCP"
}
