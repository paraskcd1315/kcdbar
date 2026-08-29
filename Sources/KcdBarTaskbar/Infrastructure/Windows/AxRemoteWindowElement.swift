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

import ApplicationServices
import CoreGraphics
import Foundation
import KcdBarTray

private typealias CreateWithRemoteTokenFn = @convention(c) (CFData) -> Unmanaged<AXUIElement>?

/** Finds a window's own Accessibility element when `AXWindows` does not list it — one on another Space. */
package enum AxRemoteWindowElement {
    private static let create: CreateWithRemoteTokenFn? = {
        guard let handle = dlopen(PrivateFrameworks.applicationServices, RTLD_LAZY),
              let symbol = dlsym(handle, PrivateFrameworks.axUIElementCreateWithRemoteToken)
        else {
            return nil
        }
        return unsafeBitCast(symbol, to: CreateWithRemoteTokenFn.self)
    }()

    package static func element(
        pid: pid_t,
        windowId: CGWindowID,
        budget: TimeInterval = WindowMatchingMetrics.remoteElementBudget
    ) -> AXUIElement? {
        guard let create = Self.create else {
            BarLog.bar.notice("element window=\(windowId) refused=noRemoteToken")
            return nil
        }
        let started = Date()
        var elementId: UInt64 = 0
        while Date().timeIntervalSince(started) < budget {
            defer { elementId += 1 }
            guard let candidate = create(AxRemoteToken.data(pid: pid, elementId: elementId) as CFData)?.takeRetainedValue(),
                  AxWindowIdBridge.windowId(of: candidate) == windowId,
                  role(of: candidate) == WindowMatchingMetrics.windowRole
            else {
                continue
            }
            BarLog.bar.notice("element window=\(windowId) swept=\(elementId) ms=\(Int(Date().timeIntervalSince(started) * 1000))")
            return candidate
        }
        BarLog.bar.notice("element window=\(windowId) refused=budget reached=\(elementId)")
        return nil
    }

    private static func role(of element: AXUIElement) -> String? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, kAXRoleAttribute as CFString, &value) == .success else {
            return nil
        }
        return value as? String
    }
}
