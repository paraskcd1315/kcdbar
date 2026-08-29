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

/** Opens another application's own New Window command, found by its key equivalent. */
@MainActor
package final class AccessibilityNewWindow: NewWindowPort {
    package init() {}

    private var capability: [pid_t: Bool] = [:]
    private var pendingPlacement: [pid_t: CGRect] = [:]
    private var observers: [pid_t: AXObserver] = [:]

    package func supportsNewWindow(pid: pid_t) -> Bool {
        if let known = capability[pid] { return known }

        let supported = newWindowItem(pid: pid) != nil
        capability[pid] = supported

        return supported
    }

    package func openNewWindow(pid: pid_t, placingOn frame: CGRect) -> Bool {
        guard let item = newWindowItem(pid: pid) else { return false }

        pendingPlacement[pid] = frame
        observeWindowCreation(pid: pid)

        return AXUIElementPerformAction(item, kAXPressAction as CFString) == .success
    }

    package func forget(pid: pid_t) {
        capability.removeValue(forKey: pid)
        pendingPlacement.removeValue(forKey: pid)
        observers.removeValue(forKey: pid)
    }

    private func newWindowItem(pid: pid_t) -> AXUIElement? {
        let application = AXUIElementCreateApplication(pid)
        guard let menuBarValue = copy(from: application, attribute: kAXMenuBarAttribute) else {
            return nil
        }
        let menuBar = menuBarValue as! AXUIElement
        guard let topLevel = copy(from: menuBar, attribute: kAXChildrenAttribute) as? [AXUIElement]
        else {
            return nil
        }
        for menu in topLevel {
            guard let items = copy(from: menu, attribute: kAXChildrenAttribute) as? [AXUIElement],
                  let container = items.first,
                  let entries = copy(from: container, attribute: kAXChildrenAttribute) as? [AXUIElement]
            else {
                continue
            }
            if let match = entries.first(where: isNewWindowCommand) {
                return match
            }
        }
        return nil
    }

    private func isNewWindowCommand(_ item: AXUIElement) -> Bool {
        guard copy(from: item, attribute: kAXMenuItemCmdCharAttribute) as? String == "N",
              copy(from: item, attribute: kAXMenuItemCmdModifiersAttribute) as? Int == 0,
              copy(from: item, attribute: kAXEnabledAttribute) as? Bool == true
        else {
            return false
        }
        return true
    }

    private func observeWindowCreation(pid: pid_t) {
        guard observers[pid] == nil else { return }

        var observer: AXObserver?
        let callback: AXObserverCallback = { _, element, _, context in
            guard let context else { return }
            let owner = Unmanaged<AccessibilityNewWindow>.fromOpaque(context).takeUnretainedValue()
            MainActor.assumeIsolated { owner.place(window: element) }
        }
        guard AXObserverCreate(pid, callback, &observer) == .success, let observer else { return }

        let application = AXUIElementCreateApplication(pid)
        AXObserverAddNotification(
            observer,
            application,
            kAXWindowCreatedNotification as CFString,
            Unmanaged.passUnretained(self).toOpaque()
        )
        CFRunLoopAddSource(CFRunLoopGetMain(), AXObserverGetRunLoopSource(observer), .defaultMode)
        observers[pid] = observer
    }

    private func place(window: AXUIElement) {
        var pid: pid_t = 0
        guard AXUIElementGetPid(window, &pid) == .success,
              let frame = pendingPlacement.removeValue(forKey: pid),
              isSettable(window, attribute: kAXPositionAttribute)
        else {
            return
        }
        var origin = CGPoint(
            x: frame.midX - NewWindowMetrics.defaultSize.width / 2,
            y: frame.midY - NewWindowMetrics.defaultSize.height / 2
        )
        let target = ScreenCoordinateConverter.toAccessibility(
            CGRect(origin: origin, size: NewWindowMetrics.defaultSize)
        )
        origin = target.origin

        guard let value = AXValueCreate(.cgPoint, &origin) else { return }

        AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, value)
    }

    private func isSettable(_ element: AXUIElement, attribute: String) -> Bool {
        var settable: DarwinBoolean = false
        guard AXUIElementIsAttributeSettable(element, attribute as CFString, &settable) == .success
        else {
            return false
        }
        return settable.boolValue
    }

    private func copy(from element: AXUIElement, attribute: String) -> CFTypeRef? {
        var value: CFTypeRef?
        guard AXUIElementCopyAttributeValue(element, attribute as CFString, &value) == .success else {
            return nil
        }
        return value
    }
}
