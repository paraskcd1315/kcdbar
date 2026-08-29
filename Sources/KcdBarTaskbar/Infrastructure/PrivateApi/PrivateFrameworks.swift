/** The private framework paths and dlsym names the bar reaches for. */
package enum PrivateFrameworks {
    package static let applicationServices =
        "/System/Library/Frameworks/ApplicationServices.framework"
        + "/Frameworks/HIServices.framework/Versions/A/HIServices"

    package static let coreDockSendNotification = "CoreDockSendNotification"
    package static let axUIElementGetWindow = "_AXUIElementGetWindow"

    package static let skyLight = "/System/Library/PrivateFrameworks/SkyLight.framework/SkyLight"
    package static let cgsMainConnectionID = "CGSMainConnectionID"
    package static let cgsCopySpacesForWindows = "CGSCopySpacesForWindows"
    package static let cgsCopyManagedDisplayForSpace = "CGSCopyManagedDisplayForSpace"
    package static let cgsManagedDisplaySetCurrentSpace = "CGSManagedDisplaySetCurrentSpace"
    package static let cgsManagedDisplayGetCurrentSpace = "CGSManagedDisplayGetCurrentSpace"
    package static let cgsHWCaptureWindowList = "CGSHWCaptureWindowList"
    package static let cgsAllSpacesMask: Int32 = 7
    package static let cgsCaptureIgnoreGlobalClipShape: UInt32 = 1 << 11

    package static let showDesktopNotification = "com.apple.showdesktop.awake"
}
