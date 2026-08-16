import Foundation

package enum PowerActionMetrics {
    package static let loginWindowBundleIdentifier = "com.apple.loginwindow"
    package static let eventTimeout: TimeInterval = 10
    package static let sleepEvent = "slep"
    package static let showRestartDialogEvent = "rrst"
    package static let showShutdownDialogEvent = "rsdn"
    package static let lockScreenToolPath =
        "/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession"
    package static let lockScreenArgument = "-suspend"
}
