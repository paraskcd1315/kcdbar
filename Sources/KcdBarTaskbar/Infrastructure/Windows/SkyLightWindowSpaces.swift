// Copyright 2026 Paras Mohandas Khanchandani Chandani
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import CoreGraphics
import Foundation

private typealias MainConnectionFn = @convention(c) () -> Int32
private typealias CopySpacesForWindowsFn = @convention(c) (Int32, Int32, CFArray) -> Unmanaged<CFArray>?
private typealias CopyManagedDisplayForSpaceFn = @convention(c) (Int32, UInt64) -> Unmanaged<CFString>?
private typealias CurrentSpaceFn = @convention(c) (Int32, CFString) -> UInt64

/** Reads each window's Space and its display's current Space through SkyLight; a missing symbol answers nothing. */
@MainActor
package struct SkyLightWindowSpaces: WindowSpaceSourcePort {
    package init() {}

    private static let calls: (MainConnectionFn, CopySpacesForWindowsFn, CopyManagedDisplayForSpaceFn, CurrentSpaceFn)? = {
        guard let handle = dlopen(PrivateFrameworks.skyLight, RTLD_LAZY),
              let connection = dlsym(handle, PrivateFrameworks.cgsMainConnectionID),
              let spaces = dlsym(handle, PrivateFrameworks.cgsCopySpacesForWindows),
              let display = dlsym(handle, PrivateFrameworks.cgsCopyManagedDisplayForSpace),
              let current = dlsym(handle, PrivateFrameworks.cgsManagedDisplayGetCurrentSpace)
        else {
            return nil
        }
        return (
            unsafeBitCast(connection, to: MainConnectionFn.self),
            unsafeBitCast(spaces, to: CopySpacesForWindowsFn.self),
            unsafeBitCast(display, to: CopyManagedDisplayForSpaceFn.self),
            unsafeBitCast(current, to: CurrentSpaceFn.self)
        )
    }()

    package func windowsOnInactiveSpaces(among windowIds: [CGWindowID]) -> Set<CGWindowID> {
        guard let (connection, spaces, display, current) = Self.calls, !windowIds.isEmpty else { return [] }
        let cid = connection()
        var found: Set<CGWindowID> = []
        var currentByDisplay: [String: UInt64] = [:]

        for windowId in windowIds {
            let ids = [NSNumber(value: windowId)] as CFArray
            guard let space = (spaces(cid, PrivateFrameworks.cgsAllSpacesMask, ids)?.takeRetainedValue() as? [UInt64])?.first,
                  let target = display(cid, space)?.takeRetainedValue() as String?
            else {
                continue
            }
            let active = currentByDisplay[target] ?? current(cid, target as CFString)
            currentByDisplay[target] = active
            if active != space {
                found.insert(windowId)
            }
        }
        return found
    }
}
