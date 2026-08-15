@MainActor
package protocol BrightnessPort {
    func state() -> BrightnessState
    func setLevel(_ level: Double)
}
