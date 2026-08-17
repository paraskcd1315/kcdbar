/** The power actions the Start menu offers. */
package enum StartPowerAction: String, CaseIterable, Sendable, Identifiable {
    case lock
    case sleep
    case restart
    case shutDown
    case logOut

    package var id: String { rawValue }

    package static var barActions: [StartPowerAction] { [.lock, .sleep, .restart, .shutDown] }

    package static var accountActions: [StartPowerAction] { [.lock, .logOut] }

    package var symbol: String {
        switch self {
        case .lock: "lock"
        case .sleep: "moon"
        case .restart: "arrow.clockwise"
        case .shutDown: "power"
        case .logOut: "rectangle.portrait.and.arrow.right"
        }
    }

    package var titleKey: String {
        switch self {
        case .lock: "start.power.lock"
        case .sleep: "start.power.sleep"
        case .restart: "start.power.restart"
        case .shutDown: "start.power.shutDown"
        case .logOut: "start.power.logOut"
        }
    }
}
