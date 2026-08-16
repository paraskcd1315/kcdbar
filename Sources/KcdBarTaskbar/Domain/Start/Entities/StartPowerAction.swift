/** The power actions the Start menu offers. */
package enum StartPowerAction: String, CaseIterable, Sendable, Identifiable {
    case lock
    case sleep
    case restart
    case shutDown

    package var id: String { rawValue }

    package var symbol: String {
        switch self {
        case .lock: "lock"
        case .sleep: "moon"
        case .restart: "arrow.clockwise"
        case .shutDown: "power"
        }
    }

    package var titleKey: String {
        switch self {
        case .lock: "start.power.lock"
        case .sleep: "start.power.sleep"
        case .restart: "start.power.restart"
        case .shutDown: "start.power.shutDown"
        }
    }
}
