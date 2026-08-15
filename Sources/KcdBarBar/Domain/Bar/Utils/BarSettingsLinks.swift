import Foundation

package enum BarSettingsLinks {
    package static let wifi = URL(string: "x-apple.systempreferences:com.apple.wifi-settings-extension")!
    package static let bluetooth = URL(
        string: "x-apple.systempreferences:com.apple.BluetoothSettings"
    )!
    package static let network = URL(
        string: "x-apple.systempreferences:com.apple.Network-Settings.extension"
    )!
}
