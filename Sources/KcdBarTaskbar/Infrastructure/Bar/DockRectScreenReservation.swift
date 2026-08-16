import CoreGraphics
import Foundation

/** Publishes the bar's strip as the dock rect, which is what every app's AppKit subtracts from its visible frame. */
@MainActor
package final class DockRectScreenReservation: ScreenReservationPort {
    private typealias MainConnection = @convention(c) () -> Int32
    private typealias GetDockRect = @convention(c) (
        Int32,
        UnsafeMutablePointer<CGRect>,
        UnsafeMutablePointer<Int32>,
        UnsafeMutablePointer<Int32>
    ) -> Int32
    private typealias SetDockRect = @convention(c) (Int32, Int32, Int32, CGRect) -> Int32

    private let connection: Int32
    private let getRect: GetDockRect
    private let setRect: SetDockRect
    private var original: (rect: CGRect, reason: Int32, orientation: Int32)?
    private var reserved: CGRect?

    package init?() {
        guard let handle = dlopen(ScreenReservationMetrics.skyLightPath, RTLD_LAZY),
              let connectionSymbol = dlsym(handle, ScreenReservationMetrics.connectionSymbol),
              let getSymbol = dlsym(handle, ScreenReservationMetrics.getSymbol),
              let setSymbol = dlsym(handle, ScreenReservationMetrics.setSymbol)
        else {
            return nil
        }
        connection = unsafeBitCast(connectionSymbol, to: MainConnection.self)()
        getRect = unsafeBitCast(getSymbol, to: GetDockRect.self)
        setRect = unsafeBitCast(setSymbol, to: SetDockRect.self)
    }

    package var isAvailable: Bool {
        let defaults = UserDefaults(suiteName: ScreenReservationMetrics.dockDomain)
        let autoHide = defaults?.bool(forKey: ScreenReservationMetrics.autoHideKey) ?? true

        return !autoHide
    }

    package func reserve(_ frame: CGRect) -> Bool {
        guard isAvailable else { return false }
        guard let current = read() else { return false }

        if original == nil {
            original = current
        }
        guard reserved != frame else { return true }
        guard setRect(connection, current.orientation, current.reason, frame) == 0 else {
            return false
        }
        reserved = frame

        return true
    }

    package func release() {
        guard let original else { return }

        _ = setRect(connection, original.orientation, original.reason, original.rect)
        self.original = nil
        reserved = nil
    }

    private func read() -> (rect: CGRect, reason: Int32, orientation: Int32)? {
        var rect = CGRect.zero
        var reason: Int32 = 0
        var orientation: Int32 = 0
        guard getRect(connection, &rect, &reason, &orientation) == 0 else { return nil }

        return (rect, reason, orientation)
    }
}
