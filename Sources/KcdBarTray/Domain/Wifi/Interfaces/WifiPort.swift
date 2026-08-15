@MainActor
package protocol WifiPort {
    func state() -> WifiState
    func setPower(_ isOn: Bool) -> Bool
    func knownNetworks() -> [WifiNetwork]
    func scan() async -> [WifiNetwork]
}
