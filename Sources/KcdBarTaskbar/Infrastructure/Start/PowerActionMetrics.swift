import Foundation

package enum PowerActionMetrics {
    package static let loginWindowBundleIdentifier = "com.apple.loginwindow"
    package static let eventTimeout: TimeInterval = 10
    package static let sleepEvent = "slep"
    package static let showRestartDialogEvent = "rrst"
    package static let showShutdownDialogEvent = "rsdn"
    package static let logOutEvent = "logo"
    package static let loginFrameworkPath =
        "/System/Library/PrivateFrameworks/login.framework/Versions/A/login"
    package static let lockScreenSymbol = "SACLockScreenImmediate"
}
