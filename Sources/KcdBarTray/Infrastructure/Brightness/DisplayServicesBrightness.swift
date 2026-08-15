import CoreGraphics
import Foundation

private typealias GetBrightnessFn =
    @convention(c) (CGDirectDisplayID, UnsafeMutablePointer<Float>) -> Int32
private typealias SetBrightnessFn =
    @convention(c) (CGDirectDisplayID, Float) -> Int32
private typealias CanChangeBrightnessFn =
    @convention(c) (CGDirectDisplayID) -> Bool

/** Display brightness, reached through DisplayServices since no public API exposes it. */
@MainActor
package struct DisplayServicesBrightness: BrightnessPort {
    package init() {}

    private static let handle = dlopen(TrayPrivateFrameworks.displayServices, RTLD_LAZY)

    private static let get: GetBrightnessFn? =
        symbol(TrayPrivateFrameworks.getBrightness)
    private static let set: SetBrightnessFn? =
        symbol(TrayPrivateFrameworks.setBrightness)
    private static let canChange: CanChangeBrightnessFn? =
        symbol(TrayPrivateFrameworks.canChangeBrightness)

    package func state() -> BrightnessState {
        guard let get = Self.get, let display = Self.mainDisplay() else { return .unavailable }
        guard Self.canChange?(display) ?? false else { return .unavailable }

        var level = Float(0)
        guard get(display, &level) == 0 else { return .unavailable }

        return BrightnessState(isAvailable: true, level: Double(level))
    }

    package func setLevel(_ level: Double) {
        guard let set = Self.set, let display = Self.mainDisplay() else { return }

        _ = set(display, Float(min(max(level, BrightnessMetrics.floor), 1)))
    }

    private static func mainDisplay() -> CGDirectDisplayID? {
        let display = CGMainDisplayID()

        return display == 0 ? nil : display
    }

    private static func symbol<T>(_ name: String) -> T? {
        guard let handle, let address = dlsym(handle, name) else { return nil }

        return unsafeBitCast(address, to: T.self)
    }
}
