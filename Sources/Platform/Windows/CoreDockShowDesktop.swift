import Foundation

private typealias CoreDockSendNotificationFn =
    @convention(c) (CFString, UnsafeMutableRawPointer?) -> Void

/** The system's own Show Desktop, reached through Dock's notification entry point. */
@MainActor
struct CoreDockShowDesktop: ShowDesktopPort {
    private static let hiServicesPath =
        "/System/Library/Frameworks/ApplicationServices.framework"
        + "/Frameworks/HIServices.framework/Versions/A/HIServices"

    private static let notificationName = "com.apple.showdesktop.awake"

    private static let send: CoreDockSendNotificationFn? = {
        guard let handle = dlopen(hiServicesPath, RTLD_LAZY),
              let symbol = dlsym(handle, "CoreDockSendNotification")
        else {
            return nil
        }
        return unsafeBitCast(symbol, to: CoreDockSendNotificationFn.self)
    }()

    var isAvailable: Bool { Self.send != nil }

    func toggle() -> Bool {
        guard let send = Self.send else { return false }

        send(Self.notificationName as CFString, nil)

        return true
    }
}
