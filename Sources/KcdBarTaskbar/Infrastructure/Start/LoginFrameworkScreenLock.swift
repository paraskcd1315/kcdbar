import Foundation

/** Locks the screen through login.framework, the route the system's own menu uses. */
@MainActor
package struct LoginFrameworkScreenLock: ScreenLockPort {
    private typealias LockScreenImmediate = @convention(c) () -> Void

    package init() {}

    package func lock() -> Bool {
        guard let handle = dlopen(PowerActionMetrics.loginFrameworkPath, RTLD_LAZY),
              let symbol = dlsym(handle, PowerActionMetrics.lockScreenSymbol)
        else {
            return false
        }
        unsafeBitCast(symbol, to: LockScreenImmediate.self)()

        return true
    }
}
