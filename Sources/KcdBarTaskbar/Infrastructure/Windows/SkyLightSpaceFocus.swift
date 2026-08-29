import CoreGraphics
import Foundation
import KcdBarTray

private typealias MainConnectionFn = @convention(c) () -> Int32
private typealias CopySpacesForWindowsFn = @convention(c) (Int32, Int32, CFArray) -> Unmanaged<CFArray>?
private typealias CopyManagedDisplayForSpaceFn = @convention(c) (Int32, UInt64) -> Unmanaged<CFString>?
private typealias CurrentSpaceFn = @convention(c) (Int32, CFString) -> UInt64
private typealias SpacesFn = @convention(c) (Int32, CFArray) -> Void
private typealias SetCurrentSpaceFn = @convention(c) (Int32, CFString, UInt64) -> Void

private struct SkyLightSpaceCalls {
    let connection: MainConnectionFn
    let spaces: CopySpacesForWindowsFn
    let display: CopyManagedDisplayForSpaceFn
    let current: CurrentSpaceFn
    let show: SpacesFn
    let hide: SpacesFn
    let setCurrent: SetCurrentSpaceFn
}

/** Brings a window's Space onto its display through SkyLight. */
@MainActor
package struct SkyLightSpaceFocus: WindowSpaceFocusPort {
    package init() {}

    private static let calls: SkyLightSpaceCalls? = {
        guard let handle = dlopen(PrivateFrameworks.skyLight, RTLD_LAZY),
              let connection = dlsym(handle, PrivateFrameworks.cgsMainConnectionID),
              let spaces = dlsym(handle, PrivateFrameworks.cgsCopySpacesForWindows),
              let display = dlsym(handle, PrivateFrameworks.cgsCopyManagedDisplayForSpace),
              let current = dlsym(handle, PrivateFrameworks.cgsManagedDisplayGetCurrentSpace),
              let show = dlsym(handle, PrivateFrameworks.cgsShowSpaces),
              let hide = dlsym(handle, PrivateFrameworks.cgsHideSpaces),
              let setCurrent = dlsym(handle, PrivateFrameworks.cgsManagedDisplaySetCurrentSpace)
        else {
            return nil
        }
        return SkyLightSpaceCalls(
            connection: unsafeBitCast(connection, to: MainConnectionFn.self),
            spaces: unsafeBitCast(spaces, to: CopySpacesForWindowsFn.self),
            display: unsafeBitCast(display, to: CopyManagedDisplayForSpaceFn.self),
            current: unsafeBitCast(current, to: CurrentSpaceFn.self),
            show: unsafeBitCast(show, to: SpacesFn.self),
            hide: unsafeBitCast(hide, to: SpacesFn.self),
            setCurrent: unsafeBitCast(setCurrent, to: SetCurrentSpaceFn.self)
        )
    }()

    package func showSpace(ofWindowId windowId: CGWindowID) -> Bool {
        guard let calls = Self.calls else {
            BarLog.bar.notice("space window=\(windowId) refused=noSkyLight")
            return false
        }
        let cid = calls.connection()
        let ids = [NSNumber(value: windowId)] as CFArray
        guard let space = (calls.spaces(cid, PrivateFrameworks.cgsAllSpacesMask, ids)?.takeRetainedValue() as? [UInt64])?.first,
              let target = calls.display(cid, space)?.takeRetainedValue()
        else {
            BarLog.bar.notice("space window=\(windowId) refused=noSpace")
            return false
        }
        let current = calls.current(cid, target)
        guard current != space else {
            BarLog.bar.notice("space window=\(windowId) shown=\(space) already")
            return true
        }
        calls.show(cid, [NSNumber(value: space)] as CFArray)
        calls.hide(cid, [NSNumber(value: current)] as CFArray)
        calls.setCurrent(cid, target, space)
        BarLog.bar.notice("space window=\(windowId) shown=\(space) hidden=\(current)")

        return true
    }
}
