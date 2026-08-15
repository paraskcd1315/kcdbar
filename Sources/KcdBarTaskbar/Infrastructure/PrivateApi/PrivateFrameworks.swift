/** The private framework paths and dlsym names the bar reaches for. */
package enum PrivateFrameworks {
    package static let applicationServices =
        "/System/Library/Frameworks/ApplicationServices.framework"
        + "/Frameworks/HIServices.framework/Versions/A/HIServices"

    package static let coreDockSendNotification = "CoreDockSendNotification"
    package static let axUIElementGetWindow = "_AXUIElementGetWindow"

    package static let showDesktopNotification = "com.apple.showdesktop.awake"
}
