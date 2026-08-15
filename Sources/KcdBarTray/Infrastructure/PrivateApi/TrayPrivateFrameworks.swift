/** The private framework paths and dlsym names the tray's readouts reach for. */
package enum TrayPrivateFrameworks {
    package static let displayServices =
        "/System/Library/PrivateFrameworks/DisplayServices.framework/DisplayServices"
    package static let ioBluetooth =
        "/System/Library/Frameworks/IOBluetooth.framework/Versions/A/IOBluetooth"

    package static let getBrightness = "DisplayServicesGetBrightness"
    package static let setBrightness = "DisplayServicesSetBrightness"
    package static let canChangeBrightness = "DisplayServicesCanChangeBrightness"
    package static let setControllerPowerState = "IOBluetoothPreferenceSetControllerPowerState"
}
