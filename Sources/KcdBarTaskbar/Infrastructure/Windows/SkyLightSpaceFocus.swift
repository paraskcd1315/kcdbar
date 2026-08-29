import CoreGraphics
import Foundation
import KcdBarTray

private typealias MainConnectionFn = @convention(c) () -> Int32
private typealias CopySpacesForWindowsFn = @convention(c) (Int32, Int32, CFArray) -> Unmanaged<CFArray>?
private typealias CopyManagedDisplayForSpaceFn = @convention(c) (Int32, UInt64) -> Unmanaged<CFString>?
private typealias SetCurrentSpaceFn = @convention(c) (Int32, CFString, UInt64) -> Void

/** Switches a display to the Space a window sits on, through SkyLight; a missing symbol answers false. */
@MainActor
package struct SkyLightSpaceFocus: WindowSpaceFocusPort {
    package init() {}

    private static let calls: (MainConnectionFn, CopySpacesForWindowsFn, CopyManagedDisplayForSpaceFn, SetCurrentSpaceFn)? = {
        guard let handle = dlopen(PrivateFrameworks.skyLight, RTLD_LAZY),
              let connection = dlsym(handle, PrivateFrameworks.cgsMainConnectionID),
              let spaces = dlsym(handle, PrivateFrameworks.cgsCopySpacesForWindows),
              let display = dlsym(handle, PrivateFrameworks.cgsCopyManagedDisplayForSpace),
              let switchSpace = dlsym(handle, PrivateFrameworks.cgsManagedDisplaySetCurrentSpace)
        else {
            return nil
        }
        return (
            unsafeBitCast(connection, to: MainConnectionFn.self),
            unsafeBitCast(spaces, to: CopySpacesForWindowsFn.self),
            unsafeBitCast(display, to: CopyManagedDisplayForSpaceFn.self),
            unsafeBitCast(switchSpace, to: SetCurrentSpaceFn.self)
        )
    }()

    package func showSpace(ofWindowId windowId: CGWindowID) -> Bool {
        guard let (connection, spaces, display, switchSpace) = Self.calls else {
            BarLog.bar.notice("space window=\(windowId) refused=noSkyLight")
            return false
        }
        let cid = connection()
        let ids = [NSNumber(value: windowId)] as CFArray
        guard let space = (spaces(cid, PrivateFrameworks.cgsAllSpacesMask, ids)?.takeRetainedValue() as? [UInt64])?.first,
              let target = display(cid, space)?.takeRetainedValue()
        else {
            BarLog.bar.notice("space window=\(windowId) refused=noSpace")
            return false
        }
        switchSpace(cid, target, space)
        BarLog.bar.notice("space window=\(windowId) shown=\(space)")

        return true
    }
}
