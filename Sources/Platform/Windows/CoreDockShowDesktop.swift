import Foundation

private typealias CoreDockSendNotificationFn =
    @convention(c) (CFString, UnsafeMutableRawPointer?) -> Void

/** The system's own Show Desktop, reached through Dock's notification entry point. */
@MainActor
struct CoreDockShowDesktop: ShowDesktopPort {
    private static let send: CoreDockSendNotificationFn? = {
        guard let handle = dlopen(PrivateFrameworks.applicationServices, RTLD_LAZY),
              let symbol = dlsym(handle, PrivateFrameworks.coreDockSendNotification)
        else {
            return nil
        }
        return unsafeBitCast(symbol, to: CoreDockSendNotificationFn.self)
    }()

    var isAvailable: Bool { Self.send != nil }

    func toggle() -> Bool {
        guard let send = Self.send else { return false }

        send(PrivateFrameworks.showDesktopNotification as CFString, nil)

        return true
    }
}
