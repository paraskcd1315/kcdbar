/** Every private framework path and dlsym name the app reaches for, in one auditable place. */
enum PrivateFrameworks {
    static let applicationServices =
        "/System/Library/Frameworks/ApplicationServices.framework"
        + "/Frameworks/HIServices.framework/Versions/A/HIServices"
    static let displayServices =
        "/System/Library/PrivateFrameworks/DisplayServices.framework/DisplayServices"
    static let ioBluetooth =
        "/System/Library/Frameworks/IOBluetooth.framework/Versions/A/IOBluetooth"

    static let coreDockSendNotification = "CoreDockSendNotification"
    static let displayServicesGetBrightness = "DisplayServicesGetBrightness"
    static let displayServicesSetBrightness = "DisplayServicesSetBrightness"
    static let displayServicesCanChangeBrightness = "DisplayServicesCanChangeBrightness"
    static let bluetoothSetControllerPowerState = "IOBluetoothPreferenceSetControllerPowerState"
    static let axUIElementGetWindow = "_AXUIElementGetWindow"

    static let showDesktopNotification = "com.apple.showdesktop.awake"
}
