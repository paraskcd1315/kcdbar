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
import Foundation

@MainActor
package final class AccessibilityGeometryObserver: WindowGeometryObserverPort {
    package init() {}

    private var observers: [pid_t: AXObserver] = [:]
    private var onChange: (() -> Void)?

    private static let notifications = [
        kAXWindowResizedNotification,
        kAXWindowMovedNotification,
        kAXWindowMiniaturizedNotification,
        kAXWindowDeminiaturizedNotification,
        kAXWindowCreatedNotification,
        kAXUIElementDestroyedNotification,
        kAXFocusedWindowChangedNotification,
        kAXTitleChangedNotification
    ]

    package func observe(pids: [pid_t], onChange: @escaping () -> Void) {
        self.onChange = onChange
        let wanted = Set(pids)

        for pid in observers.keys where !wanted.contains(pid) {
            remove(pid: pid)
        }
        for pid in wanted where observers[pid] == nil {
            add(pid: pid)
        }
    }

    package func stop() {
        observers.keys.forEach(remove(pid:))
        onChange = nil
    }

    private func add(pid: pid_t) {
        var observer: AXObserver?
        let callback: AXObserverCallback = { _, _, _, context in
            guard let context else { return }
            let owner = Unmanaged<AccessibilityGeometryObserver>.fromOpaque(context).takeUnretainedValue()
            MainActor.assumeIsolated { owner.onChange?() }
        }
        guard AXObserverCreate(pid, callback, &observer) == .success, let observer else { return }

        let application = AXUIElementCreateApplication(pid)
        let context = Unmanaged.passUnretained(self).toOpaque()
        for notification in Self.notifications {
            AXObserverAddNotification(observer, application, notification as CFString, context)
        }
        CFRunLoopAddSource(
            CFRunLoopGetMain(),
            AXObserverGetRunLoopSource(observer),
            .defaultMode
        )
        observers[pid] = observer
    }

    private func remove(pid: pid_t) {
        guard let observer = observers.removeValue(forKey: pid) else { return }
        CFRunLoopRemoveSource(
            CFRunLoopGetMain(),
            AXObserverGetRunLoopSource(observer),
            .defaultMode
        )
    }
}
